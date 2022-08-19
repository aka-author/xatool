<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:loc="http://itsurim.com/local" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="loc xat xs"
    version="2.0">
    
    <xsl:import href="../../../common/xsl-2.0/common.xsl"/>
    
    
    <xsl:template name="xat.html.img">
        <xsl:param name="id" select="''"/>
        <xsl:param name="className" select="''"/>
        <xsl:param name="src"/>
        <xsl:param name="alt" select="''"/>
        <xsl:param name="title" select="''"/>
        <xsl:param name="width" select="''"/>
        <xsl:param name="height" select="''"/>
        <xsl:param name="onclick" select="''"/>
        
        <xsl:element name="img">
            <xsl:copy-of select="xat:usefulAttr('id', $id)"/>
            <xsl:copy-of select="xat:usefulAttr('class', $className)"/>
            <xsl:attribute name="src" select="$src"/>
            <xsl:attribute name="alt" select="$alt"/>
            <xsl:copy-of select="xat:usefulAttr('title', $title)"/>
            <xsl:copy-of select="xat:usefulAttr('width', $width)"/>
            <xsl:copy-of select="xat:usefulAttr('height', $height)"/>
            <xsl:copy-of select="xat:usefulAttr('onclick', $onclick)"/>
        </xsl:element>
     
    </xsl:template>
    
</xsl:stylesheet>