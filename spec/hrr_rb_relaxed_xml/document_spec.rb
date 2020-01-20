# coding: utf-8

RSpec.describe HrrRbRelaxedXML::Document do
  describe "when instantiated with no args" do
    let(:xml_doc){ described_class.new }

    it "returns HrrRbRelaxedXML::Document instance" do
      expect( xml_doc ).to be_instance_of described_class
    end

    it "returns REXML::Document kind instance" do
      expect( xml_doc ).to be_kind_of REXML::Document
    end

    it "raises ArgumentError when #add_element with no args" do
      expect { xml_doc.add_element }.to raise_error ArgumentError
    end

    it "raises RuntimeError when #add_element with nil arg" do
      expect { xml_doc.add_element nil }.to raise_error RuntimeError
    end

    it "can add element with name argument and store it as element" do
      xml_doc.add_element 'root1'
      expect( xml_doc.elements.size ).to eq 1
      expect( xml_doc.elements[1].name ).to eq 'root1'
      expect( xml_doc.elements[1].attributes.size ).to eq 0
    end

    it "can add element with name argument with attribute and store it as element" do
      xml_doc.add_element 'root1', {'attr1' => 'val1'}
      expect( xml_doc.elements.size ).to eq 1
      expect( xml_doc.elements[1].name ).to eq 'root1'
      expect( xml_doc.elements[1].attributes.size ).to eq 1
      expect( xml_doc.elements[1].attributes['attr1'] ).to eq 'val1'
    end

    it "can add element with name argument multiple times and store them as elements" do
      xml_doc.add_element 'root1', {'attr1' => 'val1'}
      xml_doc.add_element 'root2'
      xml_doc.add_element 'root3', {'attr3' => 'val3'}
      xml_doc.add_element 'root4'
      xml_doc.add_element 'root5', {'attr5' => 'val5'}
      expect( xml_doc.elements.size ).to eq 5
      expect( xml_doc.elements[1].name ).to eq 'root1'
      expect( xml_doc.elements[2].name ).to eq 'root2'
      expect( xml_doc.elements[3].name ).to eq 'root3'
      expect( xml_doc.elements[4].name ).to eq 'root4'
      expect( xml_doc.elements[5].name ).to eq 'root5'
      expect( xml_doc.elements[1].attributes.size ).to eq 1
      expect( xml_doc.elements[2].attributes.size ).to eq 0
      expect( xml_doc.elements[3].attributes.size ).to eq 1
      expect( xml_doc.elements[4].attributes.size ).to eq 0
      expect( xml_doc.elements[5].attributes.size ).to eq 1
      expect( xml_doc.elements[1].attributes['attr1'] ).to eq 'val1'
      expect( xml_doc.elements[2].attributes['attr2'] ).to be nil
      expect( xml_doc.elements[3].attributes['attr3'] ).to eq 'val3'
      expect( xml_doc.elements[4].attributes['attr4'] ).to be nil
      expect( xml_doc.elements[5].attributes['attr5'] ).to eq 'val5'
    end
  end

  describe "when instantiated with XML string" do
    let(:xml_doc){ described_class.new xml_str }

    describe "with one root element with no attributes" do
      describe "with no XML declaration" do
        let(:xml_str){
          <<-EOB
            <root1>
              <dummy1 />
            </root1>
          EOB
        }

        it "returns HrrRbRelaxedXML::Document instance" do
          expect( xml_doc ).to be_instance_of described_class
        end

        it "returns REXML::Document kind instance" do
          expect( xml_doc ).to be_kind_of REXML::Document
        end

        it "has default XML declaration not to be written" do
          expect( xml_doc.xml_decl.version ).to eq "1.0"
          expect( xml_doc.xml_decl.encoding ).to eq "UTF-8"
          expect( xml_doc.xml_decl.standalone ).to be nil
          expect( xml_doc.xml_decl.writethis ).to be false
        end

        it "has one root element" do
          expect( xml_doc.elements.size ).to eq 1
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[1].attributes.size ).to eq 0
          expect( xml_doc.elements[1].attributes['attr1'] ).to be nil
        end

        it "can add element with name argument multiple times and store them as elements" do
          xml_doc.add_element 'root2'
          xml_doc.add_element 'root3', {'attr3' => 'val3'}
          xml_doc.add_element 'root4'
          xml_doc.add_element 'root5', {'attr5' => 'val5'}
          expect( xml_doc.elements.size ).to eq 5
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[2].name ).to eq 'root2'
          expect( xml_doc.elements[3].name ).to eq 'root3'
          expect( xml_doc.elements[4].name ).to eq 'root4'
          expect( xml_doc.elements[5].name ).to eq 'root5'
          expect( xml_doc.elements[1].attributes.size ).to eq 0
          expect( xml_doc.elements[2].attributes.size ).to eq 0
          expect( xml_doc.elements[3].attributes.size ).to eq 1
          expect( xml_doc.elements[4].attributes.size ).to eq 0
          expect( xml_doc.elements[5].attributes.size ).to eq 1
          expect( xml_doc.elements[1].attributes['attr1'] ).to be nil
          expect( xml_doc.elements[2].attributes['attr2'] ).to be nil
          expect( xml_doc.elements[3].attributes['attr3'] ).to eq 'val3'
          expect( xml_doc.elements[4].attributes['attr4'] ).to be nil
          expect( xml_doc.elements[5].attributes['attr5'] ).to eq 'val5'
        end
      end

      describe "with XML declaration" do
        let(:xml_str){
          <<-EOB
            <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
            <root1>
              <dummy />
            </root1>
          EOB
        }

        it "returns HrrRbRelaxedXML::Document instance" do
          expect( xml_doc ).to be_instance_of described_class
        end

        it "returns REXML::Document kind instance" do
          expect( xml_doc ).to be_kind_of REXML::Document
        end

        it "has XML declaration to be written" do
          expect( xml_doc.xml_decl.version ).to eq "1.0"
          expect( xml_doc.xml_decl.encoding ).to eq "UTF-8"
          expect( xml_doc.xml_decl.standalone ).to eq "yes"
          expect( xml_doc.xml_decl.writethis ).to be true
        end

        it "has one root element" do
          expect( xml_doc.elements.size ).to eq 1
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[1].attributes.size ).to eq 0
          expect( xml_doc.elements[1].attributes['attr1'] ).to be nil
        end

        it "can add element with name argument multiple times and store them as elements" do
          xml_doc.add_element 'root2'
          xml_doc.add_element 'root3', {'attr3' => 'val3'}
          xml_doc.add_element 'root4'
          xml_doc.add_element 'root5', {'attr5' => 'val5'}
          expect( xml_doc.elements.size ).to eq 5
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[2].name ).to eq 'root2'
          expect( xml_doc.elements[3].name ).to eq 'root3'
          expect( xml_doc.elements[4].name ).to eq 'root4'
          expect( xml_doc.elements[5].name ).to eq 'root5'
          expect( xml_doc.elements[1].attributes.size ).to eq 0
          expect( xml_doc.elements[2].attributes.size ).to eq 0
          expect( xml_doc.elements[3].attributes.size ).to eq 1
          expect( xml_doc.elements[4].attributes.size ).to eq 0
          expect( xml_doc.elements[5].attributes.size ).to eq 1
          expect( xml_doc.elements[1].attributes['attr1'] ).to be nil
          expect( xml_doc.elements[2].attributes['attr2'] ).to be nil
          expect( xml_doc.elements[3].attributes['attr3'] ).to eq 'val3'
          expect( xml_doc.elements[4].attributes['attr4'] ).to be nil
          expect( xml_doc.elements[5].attributes['attr5'] ).to eq 'val5'
        end
      end
    end

    describe "with one root element with attributes" do
      describe "with no XML declaration" do
        let(:xml_str){
          <<-EOB
            <root1 attr1="val1">
              <dummy1 />
            </root1>
          EOB
        }

        it "returns HrrRbRelaxedXML::Document instance" do
          expect( xml_doc ).to be_instance_of described_class
        end

        it "returns REXML::Document kind instance" do
          expect( xml_doc ).to be_kind_of REXML::Document
        end

        it "has default XML declaration not to be written" do
          expect( xml_doc.xml_decl.version ).to eq "1.0"
          expect( xml_doc.xml_decl.encoding ).to eq "UTF-8"
          expect( xml_doc.xml_decl.standalone ).to be nil
          expect( xml_doc.xml_decl.writethis ).to be false
        end

        it "has one root element" do
          expect( xml_doc.elements.size ).to eq 1
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[1].attributes.size ).to eq 1
          expect( xml_doc.elements[1].attributes['attr1'] ).to eq "val1"
        end

        it "can add element with name argument multiple times and store them as elements" do
          xml_doc.add_element 'root2'
          xml_doc.add_element 'root3', {'attr3' => 'val3'}
          xml_doc.add_element 'root4'
          xml_doc.add_element 'root5', {'attr5' => 'val5'}
          expect( xml_doc.elements.size ).to eq 5
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[2].name ).to eq 'root2'
          expect( xml_doc.elements[3].name ).to eq 'root3'
          expect( xml_doc.elements[4].name ).to eq 'root4'
          expect( xml_doc.elements[5].name ).to eq 'root5'
          expect( xml_doc.elements[1].attributes.size ).to eq 1
          expect( xml_doc.elements[2].attributes.size ).to eq 0
          expect( xml_doc.elements[3].attributes.size ).to eq 1
          expect( xml_doc.elements[4].attributes.size ).to eq 0
          expect( xml_doc.elements[5].attributes.size ).to eq 1
          expect( xml_doc.elements[1].attributes['attr1'] ).to eq "val1"
          expect( xml_doc.elements[2].attributes['attr2'] ).to be nil
          expect( xml_doc.elements[3].attributes['attr3'] ).to eq 'val3'
          expect( xml_doc.elements[4].attributes['attr4'] ).to be nil
          expect( xml_doc.elements[5].attributes['attr5'] ).to eq 'val5'
        end
      end

      describe "with XML declaration" do
        let(:xml_str){
          <<-EOB
            <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
            <root1 attr1="val1">
              <dummy />
            </root1>
          EOB
        }

        it "returns HrrRbRelaxedXML::Document instance" do
          expect( xml_doc ).to be_instance_of described_class
        end

        it "returns REXML::Document kind instance" do
          expect( xml_doc ).to be_kind_of REXML::Document
        end

        it "has XML declaration to be written" do
          expect( xml_doc.xml_decl.version ).to eq "1.0"
          expect( xml_doc.xml_decl.encoding ).to eq "UTF-8"
          expect( xml_doc.xml_decl.standalone ).to eq "yes"
          expect( xml_doc.xml_decl.writethis ).to be true
        end

        it "has one root element" do
          expect( xml_doc.elements.size ).to eq 1
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[1].attributes.size ).to eq 1
          expect( xml_doc.elements[1].attributes['attr1'] ).to eq "val1"
        end

        it "can add element with name argument multiple times and store them as elements" do
          xml_doc.add_element 'root2'
          xml_doc.add_element 'root3', {'attr3' => 'val3'}
          xml_doc.add_element 'root4'
          xml_doc.add_element 'root5', {'attr5' => 'val5'}
          expect( xml_doc.elements.size ).to eq 5
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[2].name ).to eq 'root2'
          expect( xml_doc.elements[3].name ).to eq 'root3'
          expect( xml_doc.elements[4].name ).to eq 'root4'
          expect( xml_doc.elements[5].name ).to eq 'root5'
          expect( xml_doc.elements[1].attributes.size ).to eq 1
          expect( xml_doc.elements[2].attributes.size ).to eq 0
          expect( xml_doc.elements[3].attributes.size ).to eq 1
          expect( xml_doc.elements[4].attributes.size ).to eq 0
          expect( xml_doc.elements[5].attributes.size ).to eq 1
          expect( xml_doc.elements[1].attributes['attr1'] ).to eq "val1"
          expect( xml_doc.elements[2].attributes['attr2'] ).to be nil
          expect( xml_doc.elements[3].attributes['attr3'] ).to eq 'val3'
          expect( xml_doc.elements[4].attributes['attr4'] ).to be nil
          expect( xml_doc.elements[5].attributes['attr5'] ).to eq 'val5'
        end
      end
    end

    describe "with multiple root elements with attributes" do
      describe "with no XML declaration" do
        let(:xml_str){
          <<-EOB
            <root1 attr1="val1">
              <dummy1 />
            </root1>
            <root2>
              <dummy2 />
            </root2>
            <root3 attr3="val3">
              <dummy3 />
            </root3>
          EOB
        }

        it "returns HrrRbRelaxedXML::Document instance" do
          expect( xml_doc ).to be_instance_of described_class
        end

        it "returns REXML::Document kind instance" do
          expect( xml_doc ).to be_kind_of REXML::Document
        end

        it "has default XML declaration not to be written" do
          expect( xml_doc.xml_decl.version ).to eq "1.0"
          expect( xml_doc.xml_decl.encoding ).to eq "UTF-8"
          expect( xml_doc.xml_decl.standalone ).to be nil
          expect( xml_doc.xml_decl.writethis ).to be false
        end

        it "has multiple root elements" do
          expect( xml_doc.elements.size ).to eq 3
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[2].name ).to eq 'root2'
          expect( xml_doc.elements[3].name ).to eq 'root3'
          expect( xml_doc.elements[1].attributes.size ).to eq 1
          expect( xml_doc.elements[2].attributes.size ).to eq 0
          expect( xml_doc.elements[3].attributes.size ).to eq 1
          expect( xml_doc.elements[1].attributes['attr1'] ).to eq 'val1'
          expect( xml_doc.elements[2].attributes['attr2'] ).to be nil
          expect( xml_doc.elements[3].attributes['attr3'] ).to eq 'val3'
        end

        it "can add element with name argument multiple times and store them as elements" do
          xml_doc.add_element 'root4'
          xml_doc.add_element 'root5', {'attr5' => 'val5'}
          expect( xml_doc.elements.size ).to eq 5
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[2].name ).to eq 'root2'
          expect( xml_doc.elements[3].name ).to eq 'root3'
          expect( xml_doc.elements[4].name ).to eq 'root4'
          expect( xml_doc.elements[5].name ).to eq 'root5'
          expect( xml_doc.elements[1].attributes.size ).to eq 1
          expect( xml_doc.elements[2].attributes.size ).to eq 0
          expect( xml_doc.elements[3].attributes.size ).to eq 1
          expect( xml_doc.elements[4].attributes.size ).to eq 0
          expect( xml_doc.elements[5].attributes.size ).to eq 1
          expect( xml_doc.elements[1].attributes['attr1'] ).to eq 'val1'
          expect( xml_doc.elements[2].attributes['attr2'] ).to be nil
          expect( xml_doc.elements[3].attributes['attr3'] ).to eq 'val3'
          expect( xml_doc.elements[4].attributes['attr4'] ).to be nil
          expect( xml_doc.elements[5].attributes['attr5'] ).to eq 'val5'
        end
      end

      describe "with XML declaration" do
        let(:xml_str){
          <<-EOB
            <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
            <root1 attr1="val1">
              <dummy />
            </root1>
            <root2>
              <dummy2 />
            </root2>
            <root3 attr3="val3">
              <dummy3 />
            </root3>
          EOB
        }

        it "returns HrrRbRelaxedXML::Document instance" do
          expect( xml_doc ).to be_instance_of described_class
        end

        it "returns REXML::Document kind instance" do
          expect( xml_doc ).to be_kind_of REXML::Document
        end

        it "has XML declaration to be written" do
          expect( xml_doc.xml_decl.version ).to eq "1.0"
          expect( xml_doc.xml_decl.encoding ).to eq "UTF-8"
          expect( xml_doc.xml_decl.standalone ).to eq "yes"
          expect( xml_doc.xml_decl.writethis ).to be true
        end

        it "has multiple root elements" do
          expect( xml_doc.elements.size ).to eq 3
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[2].name ).to eq 'root2'
          expect( xml_doc.elements[3].name ).to eq 'root3'
          expect( xml_doc.elements[1].attributes.size ).to eq 1
          expect( xml_doc.elements[2].attributes.size ).to eq 0
          expect( xml_doc.elements[3].attributes.size ).to eq 1
          expect( xml_doc.elements[1].attributes['attr1'] ).to eq 'val1'
          expect( xml_doc.elements[2].attributes['attr2'] ).to be nil
          expect( xml_doc.elements[3].attributes['attr3'] ).to eq 'val3'
        end

        it "can add element with name argument multiple times and store them as elements" do
          xml_doc.add_element 'root4'
          xml_doc.add_element 'root5', {'attr5' => 'val5'}
          expect( xml_doc.elements.size ).to eq 5
          expect( xml_doc.elements[1].name ).to eq 'root1'
          expect( xml_doc.elements[2].name ).to eq 'root2'
          expect( xml_doc.elements[3].name ).to eq 'root3'
          expect( xml_doc.elements[4].name ).to eq 'root4'
          expect( xml_doc.elements[5].name ).to eq 'root5'
          expect( xml_doc.elements[1].attributes.size ).to eq 1
          expect( xml_doc.elements[2].attributes.size ).to eq 0
          expect( xml_doc.elements[3].attributes.size ).to eq 1
          expect( xml_doc.elements[4].attributes.size ).to eq 0
          expect( xml_doc.elements[5].attributes.size ).to eq 1
          expect( xml_doc.elements[1].attributes['attr1'] ).to eq 'val1'
          expect( xml_doc.elements[2].attributes['attr2'] ).to be nil
          expect( xml_doc.elements[3].attributes['attr3'] ).to eq 'val3'
          expect( xml_doc.elements[4].attributes['attr4'] ).to be nil
          expect( xml_doc.elements[5].attributes['attr5'] ).to eq 'val5'
        end
      end
    end

    describe "with multiple root elements with the same name" do
      let(:xml_str){
        <<-EOB
          <root attr1="val1">
            <dummy1 />
          </root>
          <root>
            <dummy2 />
          </root>
          <root attr3="val3">
            <dummy3 />
          </root>
        EOB
      }

      it "returns HrrRbRelaxedXML::Document instance" do
        expect( xml_doc ).to be_instance_of described_class
      end

      it "returns REXML::Document kind instance" do
        expect( xml_doc ).to be_kind_of REXML::Document
      end

      it "has multiple root elements" do
        expect( xml_doc.elements.size ).to eq 3
        expect( xml_doc.elements[1].name ).to eq 'root'
        expect( xml_doc.elements[2].name ).to eq 'root'
        expect( xml_doc.elements[3].name ).to eq 'root'
        expect( xml_doc.elements[1].attributes.size ).to eq 1
        expect( xml_doc.elements[2].attributes.size ).to eq 0
        expect( xml_doc.elements[3].attributes.size ).to eq 1
        expect( xml_doc.elements[1].attributes['attr1'] ).to eq 'val1'
        expect( xml_doc.elements[2].attributes['attr2'] ).to be nil
        expect( xml_doc.elements[3].attributes['attr3'] ).to eq 'val3'
      end

      it "can add element with name argument multiple times and store them as elements" do
        xml_doc.add_element 'root'
        xml_doc.add_element 'root', {'attr5' => 'val5'}
        expect( xml_doc.elements.size ).to eq 5
        expect( xml_doc.elements[1].name ).to eq 'root'
        expect( xml_doc.elements[2].name ).to eq 'root'
        expect( xml_doc.elements[3].name ).to eq 'root'
        expect( xml_doc.elements[4].name ).to eq 'root'
        expect( xml_doc.elements[5].name ).to eq 'root'
        expect( xml_doc.elements[1].attributes.size ).to eq 1
        expect( xml_doc.elements[2].attributes.size ).to eq 0
        expect( xml_doc.elements[3].attributes.size ).to eq 1
        expect( xml_doc.elements[4].attributes.size ).to eq 0
        expect( xml_doc.elements[5].attributes.size ).to eq 1
        expect( xml_doc.elements[1].attributes['attr1'] ).to eq 'val1'
        expect( xml_doc.elements[2].attributes['attr2'] ).to be nil
        expect( xml_doc.elements[3].attributes['attr3'] ).to eq 'val3'
        expect( xml_doc.elements[4].attributes['attr4'] ).to be nil
        expect( xml_doc.elements[5].attributes['attr5'] ).to eq 'val5'
      end
    end
  end

  describe "when instantiated with XML string and context" do
    let(:xml_doc){ described_class.new xml_str, context }
    let(:xml_str){ "  <root1>\n    <dummy1 />\n  </root1>\n  " }

    describe "when context is empty" do
      let(:context){ {} }

      it "contains whitespace text nodes" do
        expect( xml_doc.children.first.class ).to eq REXML::Text
        expect( xml_doc.children.first.value ).to eq "  "
        expect( xml_doc.children.last.class ).to eq REXML::Text
        expect( xml_doc.children.last.value ).to eq "\n  "
        expect( xml_doc.elements['root1'].children.first.class ).to eq REXML::Text
        expect( xml_doc.elements['root1'].children.first.value ).to eq "\n    "
        expect( xml_doc.elements['root1'].children.last.class ).to eq REXML::Text
        expect( xml_doc.elements['root1'].children.last.value ).to eq "\n  "
      end
    end

    describe "when context is {:ignore_whitespace_nodes => :all}" do
      let(:context){ {:ignore_whitespace_nodes => :all} }

      it "doesn't contain whitespace text nodes" do
        expect( xml_doc.children.first.class ).to eq REXML::Element
        expect( xml_doc.children.first.name ).to eq "root1"
        expect( xml_doc.children.last.class ).to eq REXML::Element
        expect( xml_doc.children.last.name ).to eq "root1"
        expect( xml_doc.elements['root1'].children.first.class ).to eq REXML::Element
        expect( xml_doc.elements['root1'].children.first.name ).to eq "dummy1"
        expect( xml_doc.elements['root1'].children.last.class ).to eq REXML::Element
        expect( xml_doc.elements['root1'].children.last.name ).to eq "dummy1"
      end
    end
  end

  describe "when #clone method is called" do
    let(:xml_doc){ described_class.new xml_str }
    let(:xml_str){
      <<-EOB
        <root attr1="val1">
          <dummy1 />
        </root>
        <root>
          <dummy2 />
        </root>
        <root attr3="val3">
          <dummy3 />
        </root>
      EOB
    }

    context "#clone" do
      let(:xml_doc_clone){ xml_doc.clone }

      it "returns HrrRbRelaxedXML::Document instance" do
        expect( xml_doc_clone ).to be_instance_of described_class
      end
    end

    context "#deep_clone" do
      let(:xml_doc_deep_clone){ xml_doc.deep_clone }

      it "returns HrrRbRelaxedXML::Document instance" do
        expect( xml_doc_deep_clone ).to be_instance_of described_class
      end

      it "returns deeply cloned multiple elements " do
        expect( xml_doc_deep_clone.elements.size ).to eq 3
        expect( xml_doc_deep_clone.elements[1].name ).to eq 'root'
        expect( xml_doc_deep_clone.elements[2].name ).to eq 'root'
        expect( xml_doc_deep_clone.elements[3].name ).to eq 'root'
        expect( xml_doc_deep_clone.elements[1].attributes.size ).to eq 1
        expect( xml_doc_deep_clone.elements[2].attributes.size ).to eq 0
        expect( xml_doc_deep_clone.elements[3].attributes.size ).to eq 1
        expect( xml_doc_deep_clone.elements[1].attributes['attr1'] ).to eq 'val1'
        expect( xml_doc_deep_clone.elements[2].attributes['attr2'] ).to be nil
        expect( xml_doc_deep_clone.elements[3].attributes['attr3'] ).to eq 'val3'
        expect( xml_doc_deep_clone.elements[1].elements.size ).to eq 1
        expect( xml_doc_deep_clone.elements[2].elements.size ).to eq 1
        expect( xml_doc_deep_clone.elements[3].elements.size ).to eq 1
        expect( xml_doc_deep_clone.elements[1].elements[1].name ).to eq 'dummy1'
        expect( xml_doc_deep_clone.elements[2].elements[1].name ).to eq 'dummy2'
        expect( xml_doc_deep_clone.elements[3].elements[1].name ).to eq 'dummy3'
      end
    end
  end

  describe "when #root method is called" do
    let(:xml_doc){ described_class.new xml_str }
    let(:xml_str){
      <<-EOB
        <root1 attr1="val1">
          <dummy1 />
        </root1>
        <root2>
          <dummy2 />
        </root2>
        <root3 attr3="val3">
          <dummy3 />
        </root3>
      EOB
    }

    describe "when current context is a descendant of first root element" do
      let(:context_e){ xml_doc.elements['root1'].elements['dummy1'] }

      it "returns the context element's root node" do
        expect( context_e.root.name ).to eq "root1"
      end
    end

    describe "when current context is a descendant of second root element" do
      let(:context_e){ xml_doc.elements['root2'].elements['dummy2'] }

      it "returns the context element's root node" do
        expect( context_e.root.name ).to eq "root2"
      end
    end

    describe "when current context is a descendant of last root element" do
      let(:context_e){ xml_doc.elements['root3'].elements['dummy3'] }

      it "returns the context element's root node" do
        expect( context_e.root.name ).to eq "root3"
      end
    end
  end

  describe "when #xpath method is called" do
    let(:xml_doc){ described_class.new xml_str }
    let(:xml_str){
      <<-EOB
        <root attr1="val1">
          <dummy1 />
        </root>
        <root>
          <dummy2 />
        </root>
        <root attr3="val3">
          <dummy3 />
        </root>
      EOB
    }
    let(:root1_xpath){ xml_doc.elements[1].xpath }
    let(:root2_xpath){ xml_doc.elements[2].xpath }
    let(:root3_xpath){ xml_doc.elements[3].xpath }

    it "differentiate each root element" do
      expect( root1_xpath ).to_not eq root2_xpath
      expect( root2_xpath ).to_not eq root3_xpath
      expect( root3_xpath ).to_not eq root1_xpath
    end
  end
end
