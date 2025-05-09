<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">

    <!-- <xsl:output indent="yes"/> -->

    <!-- 
        Detecting block elements 
    -->

    <xsl:template match="*" mode="xat.dita.demix.isBlock" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ol ') and not(contains(@class, 'task/'))]"
        mode="xat.dita.demix.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ul ') and not(contains(@class, 'task/'))]"
        mode="xat.dita.demix.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/table ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/note ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/codeblock ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/div ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/equation-block ')]"
        mode="xat.dita.demix.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/equation-figure ')]"
        mode="xat.dita.demix.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/hazardstatement ')]"
        mode="xat.dita.demix.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/lines ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/lq ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/msgblock ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/pre ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/simpletable ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/screen ')]" mode="xat.dita.demix.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.demix.isBlock" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat.dita.demix.isBlock"/>
    </xsl:function>


    <!-- 
        Detecting inline nodes
    -->

    <xsl:template match="node()[name() = '']" mode="xat.dita.demix.isInline" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.demix.isBlock(.)]" mode="xat.dita.demix.isInline"
        as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[not(xat:dita.demix.isBlock(.))]" mode="xat.dita.demix.isInline"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.demix.isInline" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat.dita.demix.isInline"/>
    </xsl:function>


    <!-- 
        Detecting containers that may have mixed content
    -->

    <xsl:template match="*" mode="xat.dita.demix.isContainer" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')]" mode="xat.dita.demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/li ') and not(contains(@class, 'task/'))]"
        mode="xat.dita.demix.isContainer" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/entry ')]" mode="xat.dita.demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/stentry ')]" mode="xat.dita.demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/note ')]" mode="xat.dita.demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/section ')]" mode="xat.dita.demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/itemgroup ')]" mode="xat.dita.demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/div ')]" mode="xat.dita.demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>
    
    <xsl:function name="xat:dita.demix.isContainer" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat.dita.demix.isContainer"/>
    </xsl:function>

    <xsl:function name="xat:dita.demix.isMixed" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:sequence
            select="exists($element/*[xat:dita.demix.isBlock(.)]) and exists($element/node()[xat:dita.demix.isInline(.)])"/>

    </xsl:function>


    <!-- 
        Detecting and organizing inline nodes
    -->
    
    <xsl:function name="xat:dita.demix.followingBlockId">

        <xsl:param name="node"/>

        <xsl:value-of
            select="generate-id(($node/following-sibling::*[xat:dita.demix.isBlock(.)])[1])"/>

    </xsl:function>


    <xsl:function name="xat:dita.demix.hasPrecedingInlines" as="xs:boolean">

        <xsl:param name="block"/>

        <xsl:variable name="bid" select="generate-id($block)"/>

        <xsl:sequence
            select="exists($block/preceding-sibling::node()[xat:dita.demix.isInline(.) and xat:dita.demix.followingBlockId(.) = $bid and not(name() = '' and normalize-space(.) = '')])"/>

    </xsl:function>


    <xsl:function name="xat:dita.demix.precedingBlockId">

        <xsl:param name="node"/>

        <xsl:value-of
            select="generate-id(($node/preceding-sibling::*[xat:dita.demix.isBlock(.)])[1])"/>

    </xsl:function>


    <xsl:function name="xat:dita.demix.hasFollowingInlines" as="xs:boolean">

        <xsl:param name="block"/>

        <xsl:variable name="bid" select="generate-id($block)"/>

        <xsl:sequence
            select="exists($block/following-sibling::node()[xat:dita.demix.isInline(.) and xat:dita.demix.precedingBlockId(.) = $bid and not(name() = '' and normalize-space(.) = '')])"/>

    </xsl:function>


    <xsl:template match="*" mode="xat.dita.demix.precedingInlines">

        <xsl:variable name="cid" select="generate-id(.)"/>

        <foreign class="- topic/p xatool/demixed ">
            <xsl:choose>
                <xsl:when
                    test="preceding-sibling::*[xat:dita.demix.isInline(.) and xat:dita.demix.followingBlockId(.) = $cid]">
                    <xsl:copy-of
                        select="preceding-sibling::node()[xat:dita.demix.isInline(.) and xat:dita.demix.followingBlockId(.) = $cid]"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="rawText">
                        <xsl:value-of
                            select="preceding-sibling::node()[xat:dita.demix.followingBlockId(.) = $cid]"
                        />
                    </xsl:variable>
                    <xsl:value-of select="normalize-space($rawText)"/>
                </xsl:otherwise>
            </xsl:choose>
        </foreign>

    </xsl:template>


    <xsl:template match="*" mode="xat.dita.demix.followingInlines">

        <xsl:variable name="cid" select="generate-id(.)"/>

        <foreign class="- topic/p xatool/demixed">
            <xsl:choose>
                <xsl:when
                    test="following-sibling::node()[xat:dita.demix.isInline(.) and xat:dita.demix.precedingBlockId(.) = $cid]">
                    <xsl:copy-of
                        select="following-sibling::node()[xat:dita.demix.isInline(.) and xat:dita.demix.precedingBlockId(.) = $cid]"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="rawText">
                        <xsl:value-of
                            select="following-sibling::node()[xat:dita.demix.precedingBlockId(.) = $cid]"
                        />
                    </xsl:variable>
                    <xsl:value-of select="normalize-space($rawText)"/>
                </xsl:otherwise>
            </xsl:choose>
        </foreign>

    </xsl:template>


    <!-- 
        Getting rid of mixed content
    -->
    
    <xsl:template match="*[xat:dita.demix.isContainer(.) and xat:dita.demix.isMixed(.)]"
        mode="xat.dita.demix">

        <xsl:copy>

            <xsl:copy-of select="@*"/>

            <xsl:for-each select="*[xat:dita.demix.isBlock(.)]">

                <xsl:if test="xat:dita.demix.hasPrecedingInlines(.)">
                    <xsl:apply-templates select="." mode="xat.dita.demix.precedingInlines"/>
                </xsl:if>

                <xsl:apply-templates select="." mode="xat.dita.demix"/>

                <xsl:if test="position() = last() and xat:dita.demix.hasFollowingInlines(.)">
                    <xsl:apply-templates select="." mode="xat.dita.demix.followingInlines"/>
                </xsl:if>

            </xsl:for-each>

        </xsl:copy>

    </xsl:template>


    <xsl:template match="node()" mode="xat.dita.demix">

        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="xat.dita.demix"/>
        </xsl:copy>

    </xsl:template>


    <!--
    <xsl:template match="/">
        <xsl:apply-templates select="*" mode="xat.dita.demix"/>
    </xsl:template>
    -->

</xsl:stylesheet>
