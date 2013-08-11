require "./xm_ellie_iterator"

class XMEllie

	attr_reader :content

	def initialize (content = "")
		@content = content
	end

	def method_missing (method_name, *args, &block)
		raise "Empty element" if @content.empty?
		sub_xmls = create_sub_xmls method_name
		XMEllieIterator.new sub_xmls
	end

	def props
		return @props if (@props) 

		a = (@content.index "<") + 1
		b = (@content.index ">") - 1
		@props = create_props_map @content[a..b]
	end

	private
	def create_props_map props_string
		map = {}
		props_string = props_string.split
		props_string.shift
		props_string.each do |p|
			b = p.split "="
			sim = b[0].to_sym
			map[sim] = b[1][1..-2]
		end
		map
	end

	def create_sub_xmls root_name

		if (@content.empty?)
			return []
		end

		starts = @content.enum_for(:scan,/<#{root_name}[^>]*>/).map { |match| Regexp.last_match.begin(0)}
		ends = @content.enum_for(:scan,/<\/#{root_name}>/).map { Regexp.last_match.begin(0)}	

		check_integrity(starts, ends, root_name)

		sub_xmls = []
		starts.each_index do |i|
			content = @content[starts[i]..ends[i]]
			sub_xmls.push XMEllie.new content unless content.empty?
		end
		sub_xmls
	end

	def check_integrity starts, ends, name
		if (starts.length != ends.length)
			raise "Malformed XML"
		end

		if (starts.empty?)
			raise "Element not found #{name}"
		end
	end
end









