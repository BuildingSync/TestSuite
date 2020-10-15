from lxml import etree


def clean_files(file_name):
    """
    Cleans up a given xml file.  If unable to parse due to XMLSyntaxError, skips file.

    :param file_name: str, path to an xml file to clean up
    """
    parser = etree.XMLParser(remove_blank_text=True)
    try:
        tree = etree.parse(file_name, parser)
    except etree.XMLSyntaxError:
        print(f"Syntax Error, file not updated: {file_name}")
        return False
    etree.indent(tree)
    output = etree.tostring(tree, doctype='<?xml version="1.0" encoding="UTF-8"?>', pretty_print=True)
    with open(file_name, 'wb') as f:
        f.write(output)
    return output
