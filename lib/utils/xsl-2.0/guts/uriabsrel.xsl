<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     uriabsrel.xsl
    Usage:      Guts    
    Func:       Assembling absolute and relative URIs
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">

    <!-- 
        Modules
    -->

    <!-- Working with URIs -->
    <xsl:import href="urinorm.xsl"/>


    <!-- 
        Returns a relative URI from a file A to a file B 
    -->

    <!-- Detecting a common beginning for a source and a target -->
    <xsl:function name="xat:uri.commonBeginning">
        <xsl:param name="seqSource"/>
        <xsl:param name="seqTarget"/>

        <xsl:variable name="strSourceItem">
            <xsl:value-of select="xat:uri.serialize($seqSource[1])"/>
        </xsl:variable>

        <xsl:variable name="strTargetItem">
            <xsl:value-of select="xat:uri.serialize($seqTarget[1])"/>
        </xsl:variable>

        <xsl:if test="$strSourceItem = $strTargetItem">
            <file>
                <xsl:value-of select="$seqSource[1]"/>
            </file>
            <xsl:variable name="seqSourceNew" select="$seqSource[position() &gt; 1]"/>
            <xsl:variable name="seqTargetNew" select="$seqTarget[position() &gt; 1]"/>
            <xsl:copy-of select="xat:uri.commonBeginning($seqSourceNew, $seqTargetNew)"/>
        </xsl:if>

    </xsl:function>

    <!-- Assembling a relative path -->
    <xsl:function name="xat:uri.relative">
        <xsl:param name="strSource"/>
        <xsl:param name="strTarget"/>

        <xsl:variable name="seqSource" select="xat:uriparse.uri($strSource)/*"/>
        <xsl:variable name="seqTarget" select="xat:uriparse.uri($strTarget)/*"/>

        <xsl:variable name="seqCommon" select="xat:uri.commonBeginning($seqSource, $seqTarget)"/>
        <xsl:variable name="numStepsUp" select="count($seqSource) - count($seqCommon)"/>

        <xsl:variable name="seqRawMoveUp">
            <xsl:value-of select="
                    for $i in 1 to $numStepsUp - 1
                    return
                        '../'"/>
        </xsl:variable>

        <xsl:variable name="seqMoveUp" select="translate($seqRawMoveUp, ' ', '')"/>

        <xsl:variable name="strRelative">
            <xsl:value-of select="$seqMoveUp"/>
            <xsl:for-each select="$seqTarget[position() &gt; count($seqCommon)]">
                <xsl:value-of select="xat:uri.serialize(.)"/>
                <xsl:if test="following-sibling::*">
                    <xsl:text>/</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:value-of select="$strRelative"/>

    </xsl:function>


    <!-- 
        Assembling an absolute URI 
    -->

    <xsl:function name="xat:uri.absolute">

        <!-- E.g. file:/c:/foo/bar or file:/c:/foo/bar/ -->
        <!-- A relative URI is also allowed here -->
        <xsl:param name="strBase"/>

        <!-- E.g. kaboom.jpg or taraboom/kaboom.jpg -->
        <xsl:param name="strRelative"/>

        <xsl:choose>

            <xsl:when test="xat:uri.isRelative($strRelative)">
                <xsl:variable name="strSep">
                    <xsl:if test="not(ends-with($strBase, '/'))">
                        <xsl:text>/</xsl:text>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="xat:uri.normalize(concat($strBase, $strSep, $strRelative))"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="$strRelative"/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:function>

    <xsl:function name="xat:uri.absoluteRef">
        <xsl:param name="strBase"/>
        <xsl:param name="strRelative"/>
        <xsl:value-of select="xat:uri.absolute(xat:uri.parentFolder($strBase), $strRelative)"/>
    </xsl:function>


    <!-- 
        Detecting accurate base URI 
    -->

    <xsl:function name="xat:uri.baseURI">
        <xsl:param name="xmlItem"/>
        <xsl:variable name="strTmp" select="base-uri($xmlItem)"/>
        <xsl:choose>
            <xsl:when test="starts-with($strTmp, 'file:/')">
                <xsl:value-of select="$strTmp"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('file:/', $strTmp)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
