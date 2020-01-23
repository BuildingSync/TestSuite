#!/usr/bin/env ruby -Wall

require "nokogiri"

NAMESPACES = {
  xs: "http://www.w3.org/2001/XMLSchema",
}

def to_name_with_prefix(prefix, node)
  if !(ref = node.attribute("ref")).nil?
    ref.to_s
  elsif !(name = node.attribute("name")).nil?
    "#{prefix}:#{name.to_s}"
  else
    raise "attributes @ref or @name not found: #{node.attributes.inspect}"
  end
end

def to_name_without_prefix(prefix, node)
  if !(ref = node.attribute("ref")).nil?
    ref.to_s[(prefix.length + ":".length) .. -1]
  elsif !(type = node.attribute("type")).nil?
    type.to_s[(prefix.length + ":".length) .. -1]
  else
    raise "attributes @ref or @type not found: #{node.attributes.inspect}"
  end
end

def to_whitespace(indent, separator = "  ")
  separator * indent
end

def write!(io, xpath, indent, stack, &block)
  io.puts("#{to_whitespace(indent)}permit \"#{xpath}\" do")

  io.puts("#{to_whitespace(indent + 1)}# BEGIN \"/#{stack.join("/")}\"")

  acc = false

  if block_given?
    acc = yield acc
  end

  # unless acc
  #   io.puts("#{to_whitespace(indent + 1)}# NOTE \"/#{stack.join("/")}\" is empty")
  # end

  io.puts("#{to_whitespace(indent + 1)}# END \"/#{stack.join("/")}\"")

  io.puts("#{to_whitespace(indent)}end")

  acc
end

def process_node_for_xs_attribute!(io, prefix, node_for_xs_schema, node_for_xs_element, node_for_xs_complexType, node_for_xs_attribute, indent = 0, stack = [])
  acc = false

  if !(ref = node_for_xs_attribute.attribute("ref")).nil?
    write!(io, "@#{to_name_without_prefix(prefix, node_for_xs_attribute)}", indent, stack)

    acc = true
  elsif !(name = node_for_xs_attribute.attribute("name")).nil?
    write!(io, "@#{name}", indent, stack)

    acc = true
  else
    # NOTE Do nothing.
  end

  acc
end

def process_node_for_xs_complexType!(io, prefix, node_for_xs_schema, node_for_xs_element, node_for_xs_complexType, indent = 0, stack = [])
  write!(io, to_name_with_prefix(prefix, node_for_xs_element), indent, stack) do |acc|
    acc = node_for_xs_complexType.xpath("./xs:attribute | ./xs:simpleContent/xs:extension/xs:attribute", **NAMESPACES).sort_by { |node_for_xs_attribute|
      # to_name_with_prefix(prefix, node_for_xs_attribute)
      nil
    }.inject(acc) { |new_acc, node_for_xs_attribute|
      process_node_for_xs_attribute!(io, prefix, node_for_xs_schema, node_for_xs_element, node_for_xs_complexType, node_for_xs_attribute, indent + 1, stack + ["@#{to_name_without_prefix(prefix, node_for_xs_attribute)}"])
    }

    acc = node_for_xs_complexType.xpath("./*/xs:element", **NAMESPACES).sort_by { |new_node_for_xs_element|
      # to_name_with_prefix(prefix, new_node_for_xs_element)
      nil
    }.inject(acc) { |new_acc, new_node_for_xs_element|
      process_node_for_xs_element!(io, prefix, node_for_xs_schema, new_node_for_xs_element, indent, stack + [to_name_with_prefix(prefix, new_node_for_xs_element)]) || new_acc
    }

    acc
  end

  true
end

def process_node_for_xs_simpleType!(io, prefix, node_for_xs_schema, node_for_xs_element, node_for_xs_simpleType, indent = 0, stack = [])
  write!(io, to_name_with_prefix(prefix, node_for_xs_element), indent, stack)

  true
end

def process_node_for_xs_element!(io, prefix, node_for_xs_schema, node_for_xs_element, indent = 0, stack = [])
  acc = false

  if !(ref = node_for_xs_element.attribute("ref")).nil?
    acc = node_for_xs_schema.xpath("./xs:element[@name = '#{to_name_without_prefix(prefix, node_for_xs_element)}']", **NAMESPACES).inject(acc) { |new_acc, new_node_for_xs_element|
      process_node_for_xs_element!(io, prefix, node_for_xs_schema, new_node_for_xs_element, indent + 1, stack) || new_acc
    }

    acc = node_for_xs_schema.xpath("./xs:complexType[@name = '#{to_name_without_prefix(prefix, node_for_xs_element)}']", **NAMESPACES).inject(acc) { |new_acc, node_for_xs_complexType|
      process_node_for_xs_complexType!(io, prefix, node_for_xs_schema, node_for_xs_element, node_for_xs_complexType, indent + 1, stack) || new_acc
    }

    acc = node_for_xs_schema.xpath("./xs:simpleType[@name = '#{to_name_without_prefix(prefix, node_for_xs_element)}']", **NAMESPACES).inject(acc) { |new_acc, node_for_xs_simpleType|
      process_node_for_xs_simpleType!(io, prefix, node_for_xs_schema, node_for_xs_element, node_for_xs_simpleType, indent + 1, stack) || new_acc
    }
  elsif !(name = node_for_xs_element.attribute("name")).nil?
    if !(type = node_for_xs_element.attribute("type")).nil?
      if type.to_s.start_with?("#{prefix}:")
        acc = node_for_xs_schema.xpath("./xs:element[@name = '#{to_name_without_prefix(prefix, node_for_xs_element)}']", **NAMESPACES).inject(acc) { |new_acc, new_node_for_xs_element|
          process_node_for_xs_element!(io, prefix, node_for_xs_schema, new_node_for_xs_element, indent + 1, stack) || new_acc
        }

        acc = node_for_xs_schema.xpath("./xs:complexType[@name = '#{to_name_without_prefix(prefix, node_for_xs_element)}']", **NAMESPACES).inject(acc) { |new_acc, node_for_xs_complexType|
          process_node_for_xs_complexType!(io, prefix, node_for_xs_schema, node_for_xs_element, node_for_xs_complexType, indent + 1, stack) || new_acc
        }

        acc = node_for_xs_schema.xpath("./xs:simpleType[@name = '#{to_name_without_prefix(prefix, node_for_xs_element)}']", **NAMESPACES).inject(acc) { |new_acc, node_for_xs_simpleType|
          process_node_for_xs_simpleType!(io, prefix, node_for_xs_schema, node_for_xs_element, node_for_xs_simpleType, indent + 1, stack) || new_acc
        }
      else
        write!(io, to_name_with_prefix(prefix, node_for_xs_element), indent + 1, stack)

        acc = true
      end
    else
      acc = node_for_xs_element.xpath("./xs:element", **NAMESPACES).inject(acc) { |new_acc, new_node_for_xs_element|
        process_node_for_xs_element!(io, prefix, node_for_xs_schema, new_node_for_xs_element, indent + 1, stack) || new_acc
      }

      acc = node_for_xs_element.xpath("./xs:complexType", **NAMESPACES).inject(acc) { |new_acc, node_for_xs_complexType|
        process_node_for_xs_complexType!(io, prefix, node_for_xs_schema, node_for_xs_element, node_for_xs_complexType, indent + 1, stack) || new_acc
      }

      acc = node_for_xs_element.xpath("./xs:simpleType", **NAMESPACES).inject(acc) { |new_acc, node_for_xs_simpleType|
        process_node_for_xs_simpleType!(io, prefix, node_for_xs_schema, node_for_xs_element, node_for_xs_simpleType, indent + 1, stack) || new_acc
      }
    end
  else
    # NOTE Do nothing.
  end

  acc
end

filename, prefix, name, *args = *ARGV

doc = File.open(filename, "r") { |f| Nokogiri::XML(f) }

io = File.open("BuildingSync_schematron.rb", "w+")

doc.xpath("./xs:schema", xs: "http://www.w3.org/2001/XMLSchema").each do |node_for_xs_schema|
  io.puts("require \"nokogiri/xml/schematron/schema\"")
  io.puts("")
  io.puts("nokogiri_xml_schematron_schema = Nokogiri::XML::Schematron::Schema.new(title: \"TODO title\") do")
  io.puts("  ns(prefix: \"#{prefix}\", uri: \"#{node_for_xs_schema.namespaces["xmlns:#{prefix}"]}\")")
  io.puts("  pattern(title: \"TODO name\") do")
  io.puts("    context(\"/\") do")

  acc = false

  acc = node_for_xs_schema.xpath("./xs:element[@name = '#{name}']", **NAMESPACES).inject(acc) { |new_acc, node_for_xs_element|
    process_node_for_xs_element!(io, prefix, node_for_xs_schema, node_for_xs_element, 2, [to_name_with_prefix(prefix, node_for_xs_element)]) || new_acc
  }

  # unless acc
  #   io.puts("      # NOTE \"/\" is empty")
  # end

  io.puts("    end")
  io.puts("  end")
  io.puts("end")
  io.puts("")
  io.puts("$stdout.puts(nokogiri_xml_schematron_schema.to_builder(encoding: \"UTF-8\").to_xml)")
end
