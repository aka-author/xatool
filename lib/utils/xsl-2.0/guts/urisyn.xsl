<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     urisyn.xsl
    Usage:      Guts    
    Func:       Providing regular expressions for parsing URIs
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">

    <!-- 
        Modules
    -->

    <!-- Assembling regular expressions -->
    <xsl:import href="../regexp.xsl"/>


    <!-- 
        Assembling building blocks for URI regexps
    -->

    <!-- Characters and terms -->

    <xsl:function name="xat:urisyn.commonChar">
        <xsl:text><![CDATA[(([A-Za-z\d\-\._~])|(%[A-F\d]{2}))]]></xsl:text>
    </xsl:function>

    <xsl:function name="xat:urisyn.commonTerm">
        <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.commonChar(), '+')"/>
    </xsl:function>

    <xsl:function name="xat:urisyn.hostChar">
        <xsl:text><![CDATA[[A-Za-z\d\-_~]]]></xsl:text>
    </xsl:function>

    <xsl:function name="xat:urisyn.hostTerm">
        <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.hostChar(), '+')"/>
    </xsl:function>


    <!-- Protocol -->

    <!-- https -->
    <xsl:function name="xat:urisyn.protocol">
        <xsl:value-of select="xat:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- https: -->
    <xsl:function name="xat:urisyn.fullProtocol">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="xat:urisyn.protocol()"/>
                <xsl:text>:</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Credentials -->

    <!-- daRkLoRd -->
    <xsl:function name="xat:urisyn.login">
        <xsl:value-of select="xat:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- qwerty -->
    <xsl:function name="xat:urisyn.pwd">
        <xsl:value-of select="xat:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- :querty -->
    <xsl:function name="xat:urisyn.pwdGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>:</xsl:text>
                <xsl:value-of select="xat:urisyn.pwd()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- daRkLoRd:querty -->
    <xsl:function name="xat:urisyn.credentials">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="xat:urisyn.login()"/>
                <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.pwdGroup(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- daRkLoRd:querty@ -->
    <xsl:function name="xat:urisyn.credentialsGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="xat:urisyn.credentials()"/>
                <xsl:text>@</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Host -->

    <!-- .example -->
    <xsl:function name="xat:urisyn.hostGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>\.</xsl:text>
                <xsl:value-of select="xat:urisyn.hostTerm()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- www.example.com -->
    <xsl:function name="xat:urisyn.host">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="xat:urisyn.hostTerm()"/>
                <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.hostGroup(), '*')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Port -->

    <!-- 80AF -->
    <xsl:function name="xat:urisyn.port">
        <xsl:text><![CDATA[([\dA-F]+)]]></xsl:text>
    </xsl:function>

    <!-- :80AF -->
    <xsl:function name="xat:urisyn.portGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>:</xsl:text>
                <xsl:value-of select="xat:urisyn.port()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Host with a port number -->

    <!-- www.example.com:80AF -->
    <xsl:function name="xat:urisyn.fullHost">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="xat:urisyn.host()"/>
                <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.portGroup(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Address -->

    <!-- daRkLoRd:querty@www.example.com:80AF -->
    <xsl:function name="xat:urisyn.address">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.credentialsGroup(), '?')"/>
                <xsl:value-of select="xat:urisyn.fullHost()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- //daRkLoRd:querty@www.example.com:80AF -->
    <xsl:function name="xat:urisyn.addressGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!--
                <xsl:text>\/\/</xsl:text>
                -->
                <xsl:text>//</xsl:text>
                <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.address(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Anchor -->

    <!--  food -->
    <xsl:function name="xat:urisyn.anchor">
        <xsl:value-of select="xat:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- #food -->
    <xsl:function name="xat:urisyn.anchorGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="xat:urisyn.anchor()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Query parameters -->

    <!-- size -->
    <xsl:function name="xat:urisyn.paramName">
        <xsl:value-of select="xat:urisyn.hostTerm()"/>
    </xsl:function>

    <!-- 15 or whatever you want, say, krokodil%20begemot -->
    <xsl:function name="xat:urisyn.paramValue">
        <xsl:value-of select="xat:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- size=15 -->
    <xsl:function name="xat:urisyn.param">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="xat:urisyn.paramName()"/>
                <xsl:text>=</xsl:text>
                <xsl:value-of select="xat:urisyn.paramValue()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- &size=15 -->
    <xsl:function name="xat:urisyn.paramGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>&amp;</xsl:text>
                <xsl:value-of select="xat:urisyn.param()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- page=4&size=15 -->
    <xsl:function name="xat:urisyn.params">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="xat:urisyn.param()"/>
                <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.paramGroup(), '*')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- ?page=4&size=15 -->
    <xsl:function name="xat:urisyn.paramsGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>\?</xsl:text>
                <xsl:value-of select="xat:urisyn.params()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Path as a part of an URI (not a local OS path!) -->

    <!-- c: -->
    <xsl:function name="xat:urisyn.drive">
        <xsl:text><![CDATA[[A-Za-z]:]]></xsl:text>
    </xsl:function>

    <!-- /c: -->
    <xsl:function name="xat:urisyn.driveGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!--
                <xsl:text>\/</xsl:text>
                -->
                <xsl:text>/</xsl:text>
                <xsl:value-of select="xat:urisyn.drive()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- zoo -->
    <xsl:function name="xat:urisyn.filename">
        <xsl:value-of select="xat:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- /zoo -->
    <xsl:function name="xat:urisyn.filenameGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!--
                <xsl:text>\/</xsl:text>
                -->
                <xsl:text>/</xsl:text>
                <xsl:value-of select="xat:urisyn.filename()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- zoo/animals/wombat.phtml -->
    <xsl:function name="xat:urisyn.filePath">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="xat:urisyn.filename()"/>
                <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.filenameGroup(), '*')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- /zoo/animals/wombat.phtml -->
    <xsl:function name="xat:urisyn.filePathGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!--
                <xsl:text>\/</xsl:text>
                -->
                <xsl:text>/</xsl:text>
                <xsl:value-of select="xat:urisyn.path()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- zoo/animals/wombat.phtml?page=4&size=15#food -->
    <xsl:function name="xat:urisyn.path">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="xat:urisyn.filePath()"/>
                <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.paramsGroup(), '?')"/>
                <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.anchorGroup(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- /zoo/animals/wombat.phtml?page=4&size=15#food -->
    <xsl:function name="xat:urisyn.pathGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!-- Escaping / is not relevant for XSLT -->
                <xsl:text>/</xsl:text>
                <xsl:value-of select="xat:urisyn.path()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!--
        Basically, query parameters don't make sense for a local 
        path. Nevertheless, we allow a local path to contain 
        query parameters. Perhaps, someone will need to use this 
        in custom applications. Who knows...
    -->

    <!-- c:/htdocs/zoo/animals/wombat.phtml?page=4&size=15#food -->
    <xsl:function name="xat:urisyn.fullPath">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.drive(), '?')"/>
                <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.pathGroup(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- /c:/htdocs/zoo/animals/wombat.phtml?page=4&size=15#food -->
    <xsl:function name="xat:urisyn.fullPathGroup">
        <xsl:call-template name="xat.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!-- Escaping / is not relevant for XSLT -->
                <xsl:text>/</xsl:text>
                <xsl:value-of select="xat:urisyn.fullPath()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Any URI (an address group is optional) -->

    <!-- file:/c:/htdocs/zoo/animals/wombat.phtml?page=4&size=15#food -->
    <xsl:function name="xat:urisyn.URI">
        <xsl:call-template name="xat.regexp.wholeString">
            <xsl:with-param name="strItem">
                <xsl:call-template name="xat.regexp.sequenceGroup">
                    <xsl:with-param name="seqItems">
                        <xsl:value-of select="xat:urisyn.fullProtocol()"/>
                        <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.addressGroup(), '?')"/>
                        <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.driveGroup(), '?')"/>
                        <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.pathGroup(), '?')"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Global URI (an address group is mandatory; a drive is not permitted) -->

    <!-- http://daRkLoRd:querty@www.example.com:80/zoo/animals/wombat.py?page=5&size=15#food -->
    <xsl:function name="xat:urisyn.globalURI">
        <xsl:call-template name="xat.regexp.wholeString">
            <xsl:with-param name="strItem">
                <xsl:call-template name="xat.regexp.sequenceGroup">
                    <xsl:with-param name="seqItems">
                        <xsl:value-of select="xat:urisyn.fullProtocol()"/>
                        <xsl:value-of select="xat:urisyn.addressGroup()"/>
                        <xsl:value-of
                            select="xat:regexp.multiGroup(xat:urisyn.filePathGroup(), '?')"/>
                        <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.paramsGroup(), '?')"/>
                        <xsl:value-of select="xat:regexp.multiGroup(xat:urisyn.anchorGroup(), '?')"
                        />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

</xsl:stylesheet>
