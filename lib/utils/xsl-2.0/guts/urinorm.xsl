<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     uriquery.xsl
    Usage:      Guts    
    Func:       Normalizing URIs
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
    
    <!-- Analyzing and assembling URIs -->
    <xsl:import href="uriquery.xsl"/>
    
    
    <!-- 
        Normalizing an URI (suppressing redundant . and ..)
    -->
    
    <xsl:function name="xat:uri.normalize">
        <xsl:param name="strURI"/>
        <xsl:value-of select="$strURI"/>
    </xsl:function>
    
</xsl:stylesheet>