<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template name="xat.html.linkCss">
        <xsl:param name="href"/>
        
        <xsl:element name="link">
            <xsl:attribute name="rel" select="'stylesheet'"/>
            <xsl:attribute name="href" select="$href"/>
        </xsl:element>
        
    </xsl:template>
    
</xsl:stylesheet>