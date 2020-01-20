RSpec.describe HrrRbRelaxedXML::XPath do
  let(:xml_doc){ HrrRbRelaxedXML::Document.new xml_str }
  let(:xml_str){
    <<-EOB
      <root1 xmlns="ns1" attr="val" attr1="val1">
        <child1>
          <child11 attr="val11" />
          <child12 attr="val12" />
          <child13 attr="val13" />
        </child1>
      </root1>
      <root2 xmlns="ns2and3" attr="val" attr2="val2">
        <child2>
          <child21 attr="val21" />
          <child22 attr="val22" />
          <child23 attr="val23" />
        </child2>
      </root2>
      <root3 xmlns="ns2and3" attr="val" attr3="val3">
        <child3>
          <child31 attr="val31" />
          <child32 attr="val32" />
          <child33 attr="val33" />
        </child3>
      </root3>
    EOB
  }

  describe 'XPath is "/*"' do
    let(:xpath){ '/*' }

    it "matches every root element" do
      expect( described_class.match(xml_doc, xpath).map{|e| e.name} ).to match_array ["root1", "root2", "root3"]
    end
  end

  describe 'XPath is "//*"' do
    let(:xpath){ '//*' }

    it "matches every element" do
      expect( described_class.match(xml_doc, xpath).map{|e| e.name} ).to match_array ["root1", "root2", "root3", "child1", "child2", "child3", "child11", "child12", "child13", "child21", "child22", "child23", "child31", "child32", "child33"]
    end
  end

  describe 'XPath is "/root1/../root2"' do
    let(:xpath){ '/root1/../root2' }

    it "matches other root element from context element" do
      expect( described_class.match(xml_doc, xpath).map{|e| e.name} ).to eq ["root2"]
    end
  end

  describe 'XPath is "/*[@attr="val"]"' do
    let(:xpath){ '/*[@attr="val"]' }

    it "matches every root element that has attr=\"val\" attribute" do
      expect( described_class.match(xml_doc, xpath).map{|e| e.name} ).to match_array ["root1", "root2", "root3"]
    end
  end

  describe 'XPath is "/*[@xmlns="ns2and3"]"' do
    let(:xpath){ '/*[@xmlns="ns2and3"]' }

    it "matches every root element that has \"ns2and3\" namespace" do
      expect( described_class.match(xml_doc, xpath).map{|e| e.name} ).to match_array ["root2", "root3"]
    end
  end

  describe 'XPath is "/root2/child2/child22/preceding-sibling::*"' do
    let(:xpath){ '/root2/child2/child22/preceding-sibling::*' }

    it "matches every preceding-sibling node" do
      expect( described_class.match(xml_doc, xpath).map{|e| e.name} ).to eq ["child21"]
    end
  end

  describe 'XPath is "/root2/child2/child22/following-sibling::*"' do
    let(:xpath){ '/root2/child2/child22/following-sibling::*' }

    it "matches every following-sibling node" do
      expect( described_class.match(xml_doc, xpath).map{|e| e.name} ).to eq ["child23"]
    end
  end

  describe 'XPath is "/root2/child2/child22/preceding::*"' do
    let(:xpath){ '/root2/child2/child22/preceding::*' }

    it "matches every preceding node including other root element and its descendants" do
      expect( described_class.match(xml_doc, xpath).map{|e| e.name} ).to eq ["child21", "child13", "child12", "child11", "child1", "root1"]
    end
  end

  describe 'XPath is "/root2/child2/child22/following::*"' do
    let(:xpath){ '/root2/child2/child22/following::*' }

    it "matches every following node including other root element and its descendants" do
      expect( described_class.match(xml_doc, xpath).map{|e| e.name} ).to eq ["child23", "root3", "child3", "child31", "child32", "child33"]
    end
  end
end
