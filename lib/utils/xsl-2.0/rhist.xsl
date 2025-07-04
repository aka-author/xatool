<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     rhist.xsl    
    Usage:      Library
    Func:       Managing a history of recusrive data processing
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">
    
    <!-- 
        Local utilities
    -->
    
    <xsl:template match="*" mode="xat:rhist.id">
        <xsl:value-of select="generate-id()"/>
    </xsl:template>
    
    <xsl:template match="*[@id]" mode="xat:rhist.id">
        <xsl:value-of select="@id"/>
    </xsl:template>
    
    <xsl:function name="xat:rhist.id">
        <xsl:param name="elmSomeItem"/>
        <xsl:apply-templates select="$elmSomeItem" mode="xat:rhist.id"/>
    </xsl:function>
    

    <!-- 
        Checking a history for not containing an item 
    -->

    <!-- True if does not contain -->
    <xsl:function name="xat:rhist.isUnique" as="xs:boolean">
        <xsl:param name="elmHistory"/>
        <xsl:param name="strItemId"/>
        <xsl:value-of select="not(exists($elmHistory/item[@id = $strItemId]))"/>
    </xsl:function>

    <!-- The same but you pass an element instaed of its @id -->
    <xsl:function name="xat:rhist.isUniqueId" as="xs:boolean">
        <xsl:param name="elmHistory"/>
        <xsl:param name="elmTarget"/>
        <xsl:value-of select="not(exists($elmHistory/item[@id = xat:rhist.id($elmTarget)]))"/>
    </xsl:function>

    <!-- True if contains -->
    <xsl:function name="xat:rhist.contains" as="xs:boolean">
        <xsl:param name="elmHistory"/>
        <xsl:param name="strItemId"/>
        <xsl:value-of select="exists($elmHistory/item[@id = $strItemId])"/>
    </xsl:function>
    
    <!-- The same but you pass an element instaed of its @id -->
    <xsl:function name="xat:rhist.containsId" as="xs:boolean">
        <xsl:param name="elmHistory"/>
        <xsl:param name="elmTarget"/>
        <xsl:value-of select="exists($elmHistory/item[@id = xat:rhist.id($elmTarget)])"/>
    </xsl:function>


    <!-- 
        Detecting target items
    -->

    <xsl:function name="xat:rhist.targets" as="xs:string*">
        <xsl:param name="elmHistory"/>
        <xsl:variable name="seqLinks" select="$elmHistory//link/@ref" as="xs:string*"/>
        <xsl:variable name="seqItems" select="$elmHistory//item/@id" as="xs:string*"/>
        <xsl:copy-of select="$seqLinks[not(. = $seqItems)]"/>
    </xsl:function>


    <!-- 
        Assembling a link
    -->

    <!-- A reference with a payload -->
    <xsl:function name="xat:rhist.link">
        <xsl:param name="strRefItemId"/>
        <xsl:param name="anyPayload"/>
        <link>
            <xsl:attribute name="ref" select="$strRefItemId"/>
            <xsl:if test="$anyPayload != ''">
                <payload>
                    <xsl:copy-of select="$anyPayload"/>
                </payload>
            </xsl:if>
        </link>
    </xsl:function>

    <!-- Just a reference  -->
    <xsl:function name="xat:rhist.link">
        <xsl:param name="strRefItemId"/>
        <xsl:copy-of select="xat:rhist.link($strRefItemId, '')"/>
    </xsl:function>


    <!-- 
        Assembling a node
    -->

    <!-- An node with links and a payload -->
    <xsl:function name="xat:rhist.node">
        <xsl:param name="strItemId"/>
        <xsl:param name="xmlLinks"/>
        <xsl:param name="anyPayload"/>
        <item>
            <xsl:attribute name="id" select="$strItemId"/>
            <links>
                <xsl:copy-of select="$xmlLinks"/>
            </links>
            <xsl:if test="$anyPayload != ''">
                <payload>
                    <xsl:copy-of select="$anyPayload"/>
                </payload>
            </xsl:if>
        </item>
    </xsl:function>

    <!-- Just a node with links -->
    <xsl:function name="xat:rhist.node">
        <xsl:param name="strItemId"/>
        <xsl:param name="xmlLinks"/>
        <xsl:copy-of select="xat:rhist.node($strItemId, $xmlLinks, '')"/>
    </xsl:function>


    <!-- 
        Assembling a simple item
    -->

    <!-- An item with a payload -->
    <xsl:function name="xat:rhist.item">
        <xsl:param name="strItemId"/>
        <xsl:param name="anyPayload"/>
        <item>
            <xsl:attribute name="id" select="$strItemId"/>
            <xsl:if test="$anyPayload != ''">
                <payload>
                    <xsl:copy-of select="$anyPayload"/>
                </payload>
            </xsl:if>
        </item>
    </xsl:function>

    <!-- Just a node -->
    <xsl:function name="xat:rhist.item">
        <xsl:param name="strItemId"/>
        <xsl:copy-of select="xat:rhist.item($strItemId, '')"/>
    </xsl:function>


    <!-- 
        Pushing an item to a history 
    -->

    <xsl:function name="xat:rhist.push">
        <xsl:param name="elmHistory"/>
        <xsl:param name="elmItem"/>

        <history>
            <xsl:copy-of select="$elmHistory/item"/>
            <xsl:copy-of select="$elmItem"/>
        </history>

    </xsl:function>

    <!-- The same but you pass an element instaed of its @id -->
    <xsl:function name="xat:rhist.pushIdAsItem">
        <xsl:param name="elmHistory"/>
        <xsl:param name="elmTarget"/>
        <xsl:copy-of select="xat:rhist.push($elmHistory, xat:rhist.item(xat:rhist.id($elmTarget)))"/>
    </xsl:function>


    <!-- 
        Creating a new history 
    -->

    <!-- Creating a new history and pushing there an item at once -->
    <xsl:function name="xat:rhist.init">
        <xsl:param name="elmItem"/>

        <history>
            <xsl:copy-of select="$elmItem"/>
        </history>

    </xsl:function>

    <!-- Just creating an empty history -->
    <xsl:function name="xat:rhist.new">
        <history/>
    </xsl:function>


</xsl:stylesheet>
