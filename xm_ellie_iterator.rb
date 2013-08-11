#TODO: Starting-closing elements. (e.g. <first />)

class XMEllieException
end

class XMEllieIterator < Array

	def method_missing (m, *args, &block)
		a = []

		each do |x|
			begin
				b = (x.method_missing m, args, block)
				a.concat b
			rescue
			end
		end

		if (a.empty?)
			raise "Element not found #{m} or Malformed XML"
		end

		XMEllieIterator.new a 
	end

	def content
		collect do |x|
			content = x.content
			
			a = (content.index ">") + 1
			b = (content.rindex "<") - 1
			content[a..b].strip
		end
	end
end
