require "rspec"
require "./xm_ellie"

describe XMEllie do

	describe "Emptyness" do
		
		it "Simple emptyness" do
			xml = XMEllie.new
			expect { xml.first }.to raise_error
		end

		it "Content emptyness" do
			xml = XMEllie.new "<first></first>"
			[""].should eq xml.first.content
		end

		it "Content emptyness" do
			xml = XMEllie.new "<first></first>"
			expect { xml.foo }.to raise_error
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

	describe "Contents" do

		it "Root element" do 
			xml = XMEllie.new "<first></first>"
			"<first></first>".should eq xml.content
		end
		
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

	describe "Adavanced array of elements" do

		it "Half three levels" do
			xml = XMEllie.new '<first><second></second><second><third>content2</third></second></first>'
			["content2"].should eq xml.first.second.third.content
		end

		it "Three levels" do
			xml = XMEllie.new '<first><second><third>content1</third></second><second><third>content2</third></second></first>'
			["content1", "content2"].should eq xml.first.second.third.content
		end

		it "Complex levels" do
			xml = XMEllie.new '<first><second><third><fourth>content1</fourth></third></second><second><third>content2</third></second></first>'
			["content1"].should eq xml.first.second.third.fourth.content
			["<fourth>content1</fourth>", "content2"].should eq xml.first.second.third.content #should be this way?
		end
	end

	describe "Props" do

		it "Simple property" do
			xml = XMEllie.new '<first time="12345"></first>'
			[""].should eq xml.first.content
		end

		# it "Simple property" do
		# 	xml = XMEllie.new '<first time="12345"></first>'
		# 	[:time => 12345].should eq xml.first.props
		# end
	end
end