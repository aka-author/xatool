<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     winpath.xsl
    Usage:      Guts    
    Func:       Parsing and assembling Windows paths
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cpm="http://cpmonster.com/xmlns/cpm"
    exclude-result-prefixes="cpm xs" version="2.0">

    <!-- 
        Modules
    -->

    <!-- Working with URIs -->
    <xsl:import href="uri.xsl"/>
    

    <!-- 
        Converting a Windows path to an URI
    -->
    
    <xsl:template match="*[lower-case(@os) = 'windows']" mode="cpm.path.2uri">

        <xsl:variable name="strIRI">
            <xsl:text>file:/</xsl:text>
            <xsl:value-of select="translate(@path, '\', '/')"/>
        </xsl:variable>

        <xsl:value-of select="iri-to-uri($strIRI)"/>

    </xsl:template>


    <!-- 
        Converting an URI to a Windows path
    -->
    
    <xsl:template match="*[lower-case(@os) = 'windows']" mode="cpm.uri.2path">        

        <xsl:variable name="strRawPath">
            <xsl:value-of select="cpm:uri.localFile(@uri)"/>
        </xsl:variable>

        <xsl:value-of select="cpm:encoding.decodeURI(translate($strRawPath, '/', '\'))"/>

    </xsl:template>

</xsl:stylesheet>
