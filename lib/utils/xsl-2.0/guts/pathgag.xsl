<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     pathgag.xsl
    Usage:      Guts    
    Func:       Parsing and assembling dummy paths
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs"
    version="2.0">
    
    <!-- 
        Modules
    -->
    
    <!-- Working with URIs -->
    <xsl:import href="uri.xsl"/>
    
    
    <!-- 
        A path to an URI
    -->
    <xsl:template match="*" mode="xat:path.2uri">
        <xsl:value-of select="@path"/>
    </xsl:template>
    
    
    <!-- 
        An URI to a path 
    -->
    <xsl:template match="*" mode="xat:uri.2path">
        <xsl:value-of select="@uri"/>
    </xsl:template>
          
    
</xsl:stylesheet>