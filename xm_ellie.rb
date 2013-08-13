require "./xm_ellie_iterator"

class XMEllie

	attr_reader :content

	def initialize (content = "")
		@content = content
	end

	def method_missing (method_name, *args, &block)
		raise "Empty element" if @content.empty?
		sub_xmls = create_sub_xmls method_name
		return nil if sub_xmls.empty?
		XMEllieIterator.new sub_xmls
	end

	def props
		return @props if (@props) 

		a = (@content.index ">") - 1
		@props = create_props_map @content[0..a]
	end

	private
	def create_props_map props_string
		map = {}
		props_string = props_string.gsub /<\w*\ /, ""
		props_string = props_string.enum_for(:scan,/\w+=\"[^\"]*\"/)
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

		starts = @content.enum_for(:scan,/<#{root_name}[^>]*>/).map { Regexp.last_match.begin(0) }
		ends = @content.enum_for(:scan,/<\/#{root_name}>/).map { Regexp.last_match.begin(0) }	

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
	end
end









