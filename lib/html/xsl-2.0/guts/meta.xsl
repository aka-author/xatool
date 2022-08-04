<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xat xs"
    version="2.0">
    
    <xsl:import href="../../../common/xsl-2.0/common.xsl"/>
    
    <xsl:template name="xat.html.meta">
        <xsl:param name="name"/>
        <xsl:param name="content" select="''"/>
        <xsl:param name="charset" select="''"/>
        <xsl:param name="httpEquiv" select="''"/>
        
        <xsl:attribute name="name" select="$name"/>
        
        <xsl:copy-of select="xat:usefulAttr('content', $content)"/>
        <xsl:copy-of select="xat:usefulAttr('charset', $charset)"/>
        <xsl:copy-of select="xat:usefulAttr('http-equiv', $httpEquiv)"/>
 
    </xsl:template>
        
</xsl:stylesheet>