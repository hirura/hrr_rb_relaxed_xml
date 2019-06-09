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
      case element
      when nil
        super
      else
        child_e = @elements.add element
        child_e.add_attributes attrs
        child_e
      end
    end
  end
end
