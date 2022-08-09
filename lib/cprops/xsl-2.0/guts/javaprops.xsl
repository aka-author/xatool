<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Props
    Module:     props.xsl    
    Usage:      Library
    Func:       Parsing property text files
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cpm="http://cpmonster.com/xmlns/cpm"
    exclude-result-prefixes="cpm xs" version="2.0">

    <!-- 
        Modules
    -->
    
    <xsl:import href="../../utils/xsl-2.0/morestr.xsl"/>


    <!-- Extracting a property name from a propery line -->
   <xsl:function name="cpm:props.name">
        <xsl:param name="strPropLine"/>
        <xsl:value-of select="normalize-space(substring-before($strPropLine, '='))"/>
    </xsl:function>

    <!-- Extracting a property value from a property line -->
    <xsl:function name="cpm:props.value">
        <xsl:param name="strPropLine"/>
        <xsl:value-of select="normalize-space(substring-after($strPropLine, '='))"/>
    </xsl:function>

    <!-- Assembling a property -->
    <xsl:function name="cpm:props.property">
        <xsl:param name="strName"/>
        <xsl:param name="strValue"/>
        <xsl:element name="property">
            <xsl:attribute name="name" select="$strName"/>
            <xsl:value-of select="$strValue"/>
        </xsl:element>
    </xsl:function>
       
    <!-- Assembling a pattern for useless lines -->
    <xsl:function name="cpm:props.uselessLinePattern">
        <xsl:text>(^[\s\t]*$)|(^([\s\t]*)(#|!)(.*))</xsl:text>
    </xsl:function>

    <!-- Parsing property text -->    
    <xsl:function name="cpm:props.parse">
        <xsl:param name="strText"/>
        
        <xsl:variable name="strExcludePattern">            
            <xsl:value-of select="cpm:props.uselessLinePattern()"/>
        </xsl:variable>

        <xsl:variable name="seqPropLines" as="xs:string*">
            <xsl:copy-of select="cpm:strlines.splitExclude($strText, $strExcludePattern)"/>
        </xsl:variable>

        <xsl:for-each select="$seqPropLines">
            <xsl:variable name="strName" select="cpm:props.name(.)"/>
            <xsl:variable name="strValue" select="cpm:props.value(.)"/>
            <xsl:copy-of select="cpm:props.property($strName, $strValue)"/>
        </xsl:for-each>

    </xsl:function>

</xsl:stylesheet>
