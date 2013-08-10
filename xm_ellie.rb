#TODO: Starting-closing elements. (e.g. <first />)

class XMEllie

	def initialize (xmls = [])
		@xmls = (xmls.is_a? String) ? [xmls] : xmls
	end

	def method_missing (m, *args, &block)
		sub_xmls = []

		raise "Error" if @xmls.empty?
		
		@xmls.each do |xml|  
			b = xml.enum_for(:scan,/<#{m}[^>]*>/).map { |match| Regexp.last_match.begin(0) + match.length }
			e = xml.enum_for(:scan,/<\/#{m}>/).map { Regexp.last_match.begin(0) - 1 }		

			b.each_index do |i|
				sub_xmls.push b[i] == e[i] ? "" : xml[b[i]..e[i]]
			end
		end

		XMEllie.new sub_xmls
	end

	def value
		@xmls.length == 1 ? @xmls[0] : @xmls
	end
end

require "rspec"

describe XMEllie do

	# describe "Emptyness" do
	# 	before { @xml = XMEllie.new }
		
	# 	it "Bla" do
	# 		@xml.first.should_raise "Error"
	# 	end
	# end

	describe "Single elements" do
		before { @xml = XMEllie.new '<first><seconda>contenta</seconda><secondb>contentb</secondb></first>' }

		it "First element" do
			"<seconda>contenta</seconda><secondb>contentb</secondb>".should eq @xml.first.value
		end

		it "Second element [0]" do
			"contenta".should eq @xml.first.seconda.value
		end

		it "Second element [1]" do
			"contentb".should eq @xml.first.secondb.value
		end

		it "Both elements" do
			"contenta".should eq @xml.first.seconda.value
			"contentb".should eq @xml.first.secondb.value
		end
	end

	describe "Array of elements" do
		before { @xml = XMEllie.new '<first><second>content1</second><second>content2</second></first>' }		

		it "First element" do
			"<second>content1</second><second>content2</second>".should eq @xml.first.value
		end

		it "First array" do
			["content1", "content2"].should eq @xml.first.second.value
		end

		it "First array" do
			["content1", "content2"].should eq @xml.first.second.value
		end
	end

	describe "Elements with properties" do
		before { @xml = XMEllie.new '<first time="123123">content</first>' }		

		it "First content" do
			"content".should eq @xml.first.value
		end
	end
end