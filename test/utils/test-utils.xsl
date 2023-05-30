<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">

    <xsl:import href="../../lib/utils/xsl-2.0/pathuri.xsl"/>
    
    <xsl:output method="text"/>

    <xsl:template match="/">

        <xsl:variable name="uri"
            select="'file:/C:/privat/misha/tomsoft/src/src/content/topics/tutorials/perspectives/gettingStarted.xml'"/>
        
        <xsl:variable name="path"
            select="'C:\privat\misha\tomsoft\src\src\content\topics\tutorials\perspectives\gettingStarted.xml'"/>        

        <xsl:if test="not(xat:uri.isURI($path))">
            <xsl:value-of select="xat:path.2uri($path, xat:path.os($path))"/>  
        </xsl:if>
        
        <xsl:text disable-output-escaping="yes">&#13;</xsl:text>
        
        <xsl:if test="xat:uri.isURI($uri)">
            <xsl:value-of select="$uri"/> 
        </xsl:if>

    </xsl:template>
    
    
</xsl:stylesheet>
