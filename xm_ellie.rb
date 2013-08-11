#TODO: Starting-closing elements. (e.g. <first />)

class XMEllieException
end

class XMEllies

	attr_reader :xmls

	def initialize(xmls = [])
		@xmls = xmls
	end

	def method_missing (m, *args, &block)
		a = []

		@xmls.each do |x|
			begin
				b = (x.method_missing m, args, block)
				a.concat b.xmls
			rescue
			end
		end

		if (a.empty?)
			raise "Element not found #{m}"
		end

		XMEllies.new a 
	end

	def props 
		@xmls.each do |x|
			content = x.content
			a = (content.index "<") + 1
			b = (content.rindex ">") - 1

			create_props_map content[a..b]
		end
	end

	def content
		@xmls.collect do |x|
			content = x.content
			
			a = (content.index ">") + 1
			b = (content.rindex "<") - 1
			content[a..b]
		end
	end

	private
	def create_props_map props_string
		map = {}
		props_string.split.shift
		props_string.each do |p|
			b = p.split "="
			map.put b[0].to_sym, b[1]
		end
		p map
		map
	end
end

class XMEllie

	attr_reader :content

	def initialize (content = "")
		@content = content
	end

	def method_missing (method_name, *args, &block)
		raise "Empty element" if @content.empty?
		sub_xmls = create_sub_xmls method_name
		XMEllies.new sub_xmls
	end

	private
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









