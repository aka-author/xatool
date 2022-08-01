<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cpm="http://cpmonster.com/xmlns/cpm"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="cpm xs"
    version="2.0">
    
    <xsl:function name="cpm:html5Doctype">
        <xsl:text><![CDATA[<!DOCTYPE html>]]></xsl:text>
    </xsl:function>
    
</xsl:stylesheet>