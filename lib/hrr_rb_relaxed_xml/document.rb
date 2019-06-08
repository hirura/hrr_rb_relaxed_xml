# coding: utf-8
# vim: et ts=2 sw=2

require 'rexml/document'

module HrrRbRelaxedXML
  class Document < REXML::Document
    def add child
      case child
      when REXML::XMLDecl, REXML::DocType
        super
      else
        child.parent = self
        @children << child
        child
      end
    end
    alias :<< :add

    def add_element element, attrs={}
      if element.nil?
        super
      else
        child_e = @elements.add element
        attrs.each do |k, v|
          child_e.attributes[k] = v
        end
        child_e
      end
    end
  end
end
