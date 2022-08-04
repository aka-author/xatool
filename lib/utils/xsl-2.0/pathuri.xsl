<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     pathuri.xsl    
    Usage:      Library
    Func:       Working with paths and URIs
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs"
    version="2.0">

    <!-- 
        Modules 
    -->
    
    <!-- Default templates for parsing and assembling paths -->
    <xsl:import href="guts/pathgag.xsl"/>
    
    <!-- Parsing and assembling Unix paths -->
    <xsl:import href="guts/pathunix.xsl"/>
    
    <!-- Parsing and assembling Windows paths -->
    <xsl:import href="guts/pathwin.xsl"/>
    
    
    
    
    <!-- 
        If you have got an URI:
        * Just do that what you need to do
        
        If you have got a path:
        1. Convert a path to an URI
        2. Do that what you need to do with the URI
        3. Convert the URI back to a path
    -->    

 
    <!-- 
        Converting paths to URIs and vice versa
    -->

    <!-- A path to an URI -->
    <xsl:function name="xat:path.2uri">
        <xsl:param name="strPath"/>
        <xsl:param name="strSourceOS"/>
        <xsl:variable name="xmlData">
            <data os="{$strSourceOS}" path="{$strPath}"/>
        </xsl:variable>
        <xsl:apply-templates select="$xmlData/data" mode="xat.path.2uri"/>
    </xsl:function>
        
    <!-- An URI to a path -->
    <xsl:function name="xat:uri.2path">
        <xsl:param name="strURI"/>
        <xsl:param name="strTargetOS"/>
        <xsl:variable name="xmlData">
            <data os="{$strTargetOS}" uri="{$strURI}"/>
        </xsl:variable>
        <xsl:apply-templates select="$xmlData/data" mode="xat.uri.2path"/>
    </xsl:function>

    
</xsl:stylesheet>
