#TODO: Starting-closing elements. (e.g. <first />)

class XMEllieException
end

class XMEllies

	def initialize(xml)
		@xml = xml
	end

	def method_missing (m, *args, &block)
		@xml[0].method_missing m, args, block
	end

	def content
		@xml.collect { |x| x.content }
	end

end

class XMEllie

	def initialize (xmls = [])
		@xmls = xmls
	end

	def method_missing (m, *args, &block)
		raise "Empty element" if @xmls.empty?
		sub_xmls = parse m;
		xm_ellies = sub_xmls.collect { |sub_xml| XMEllie.new sub_xml }
		XMEllies.new xm_ellies
	end

	def content
		@xmls
	end

	private
	def parse tag_name
		sub_xmls = []
		@xmls

		if (@xmls.empty?)
			return []
		end

		b = @xmls.enum_for(:scan,/<#{tag_name}[^>]*>/).map { |match| Regexp.last_match.begin(0) + match.length }
		e = @xmls.enum_for(:scan,/<\/#{tag_name}>/).map { Regexp.last_match.begin(0) - 1}	

		check_matches(b, e)

		b.each_index do |i|
			content = @xmls[b[i]..e[i]]
			sub_xmls.push content unless content.empty?
		end

		sub_xmls
	end

	def check_matches b, e
		if (b.length != e.length)
			raise "Malformed XML"
		end

		if (b.empty?) 
			raise "Element not found"
		end
	end
end

require "rspec"

describe XMEllie do

	describe "Emptyness" do
		
		it "Simple emptyness" do
			xml = XMEllie.new
			expect { xml.first }.to raise_error
		end

		it "Composite emptyness" do
			xml = XMEllie.new "<first></first>"
			first = xml.first
			expect {first.second}.to raise_error
		end

		it "Conditional emptyness" do
			xml = XMEllie.new "<first><thrid></third></first>"
			first = xml.first
			expect {first.second}.to raise_error
		end
	end

	describe "Malformed" do
		it "Missing closing tag" do
			xml = XMEllie.new "<first>"
			expect { xml.first }.to raise_error
		end

		it "Missing opening tag" do
			xml = XMEllie.new "</first>"
			expect { xml.first }.to raise_error
		end

		it "Closing and opening different tag" do
			xml = XMEllie.new "<first></second>"
			expect { xml.first }.to raise_error
			expect { xml.second }.to raise_error
		end
	end

	describe "Single elements" do
		before { @xml = XMEllie.new '<first><seconda>contenta</seconda><secondb>contentb</secondb></first>' }

		it "First element" do
			["<seconda>contenta</seconda><secondb>contentb</secondb>"].should eq @xml.first.content
		end

		it "Second element [0]" do
			["contenta"].should eq @xml.first.seconda.content
		end

		it "Second element [1]" do
			["contentb"].should eq @xml.first.secondb.content
		end

		it "Both elements" do
			["contenta"].should eq @xml.first.seconda.content
			["contentb"].should eq @xml.first.secondb.content
		end
	end

	describe "Array of elements" do
		before { @xml = XMEllie.new '<first><second>content1</second><second>content2</second></first>' }		

		it "First element" do
			["<second>content1</second><second>content2</second>"].should eq @xml.first.content
		end

		it "First array" do
			["content1", "content2"].should eq @xml.first.second.content
		end

		it "First array" do
			["content1", "content2"].should eq @xml.first.second.content
		end
	end
end