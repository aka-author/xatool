<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     parseury.xsl
    Usage:      Guts    
    Func:       Parsing and assembling paths and URIs
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cpm="http://cpmonster.com/xmlns/cpm"
    exclude-result-prefixes="cpm xs" version="2.0">

    <!-- 
        Modules 
    -->

    <!-- Extra string functions -->
    <xsl:import href="../morestr.xsl"/>

    <!-- Regular expressions for parsing URIs-->
    <xsl:import href="urisyn.xsl"/>
    

    <!-- 
        Parsing URIs
    -->

    <!-- page=1&size=10 -->
    <xsl:function name="cpm:uriparse.params">
        <xsl:param name="strParams"/>
        <xsl:variable name="seqParams" select="tokenize($strParams,'&amp;')" as="xs:string*"/>
        <xsl:for-each select="$seqParams">
            <param>
                <xsl:attribute name="name" select="substring-before(., '=')"/>
                <xsl:attribute name="value" select="substring-after(., '=')"/>
            </param>
        </xsl:for-each>
    </xsl:function>

    <!-- wombat.html -->
    <xsl:function name="cpm:parseuri.filename">
        <xsl:param name="strFilename"/>
        <xsl:choose>
            <xsl:when test="contains($strFilename, '.')">
                <base>
                    <xsl:value-of select="cpm:morestr.reverseAfter($strFilename, '.')"/>
                </base>
                <type>
                    <xsl:value-of select="cpm:morestr.reverseBefore($strFilename, '.')"/>
                </type>
            </xsl:when>
            <xsl:otherwise>
                <base>
                    <xsl:value-of select="$strFilename"/>
                </base>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- c:/zoo/animals/wombat.html or zoo/animals/wombat.html -->
    <xsl:function name="cpm:uriparse.localFile">
        <xsl:param name="strLocalPath"/>
        <xsl:variable name="seqFSObjects" select="tokenize($strLocalPath, '/')"/>
        <xsl:for-each select="$seqFSObjects">
            <xsl:choose>
                <xsl:when test="contains(., ':')">
                    <drive>
                        <xsl:value-of select="substring-before(., ':')"/>
                    </drive>
                </xsl:when>
                <xsl:when test="position() != last()">
                    <folder>
                        <xsl:copy-of select="cpm:parseuri.filename(.)"/>
                    </folder>
                </xsl:when>
                <xsl:otherwise>
                    <file>
                        <xsl:copy-of select="cpm:parseuri.filename(.)"/>
                    </file>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>

    <!-- /zoo/animals/wombat.html?page=1&amp;size=10#food -->
    <xsl:function name="cpm:uriparse.localPathGroup">
        <xsl:param name="strPathGroup"/>
        <xsl:variable name="strPath">
            <xsl:choose>
                <xsl:when test="starts-with($strPathGroup, '/')">
                    <xsl:value-of select="substring-after($strPathGroup, '/')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$strPathGroup"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($strPath, '?') and contains($strPath, '#')">
                <xsl:copy-of select="cpm:uriparse.localFile(substring-before($strPath, '?'))"/>
                <xsl:variable name="strParams" select="cpm:morestr.afterBefore($strPath, '?', '#')"/>
                <xsl:copy-of select="cpm:uriparse.params($strParams)"/>
                <anchor>
                    <xsl:value-of select="substring-after($strPath, '#')"/>
                </anchor>
            </xsl:when>
            <xsl:when test="contains($strPath, '?') and not(contains($strPath, '#'))">
                <xsl:copy-of select="cpm:uriparse.localFile(substring-before($strPath, '?'))"/>
                <xsl:variable name="strParams" select="substring-after($strPath, '?')"/>
                <xsl:copy-of select="cpm:uriparse.params($strParams)"/>
            </xsl:when>
            <xsl:when test="not(contains($strPath, '?')) and contains($strPath, '#')">
                <xsl:copy-of select="cpm:uriparse.localFile(substring-before($strPath, '#'))"/>
                <anchor>
                    <xsl:value-of select="substring-after($strPath, '#')"/>
                </anchor>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="cpm:uriparse.localFile($strPath)"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>

    <!-- www.example.com:80 -->
    <xsl:function name="cpm:uriparse.hostPort">
        <xsl:param name="strHostPort"/>
        <xsl:choose>
            <xsl:when test="contains($strHostPort, ':')">
                <host>
                    <xsl:value-of select="substring-before($strHostPort, ':')"/>
                </host>
                <port>
                    <xsl:value-of select="substring-after($strHostPort, ':')"/>
                </port>
            </xsl:when>
            <xsl:otherwise>
                <host>
                    <xsl:value-of select="$strHostPort"/>
                </host>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- adm:qwerty -->
    <xsl:function name="cpm:uriparse.credentials">
        <xsl:param name="strCredentials"/>
        <xsl:choose>
            <xsl:when test="contains($strCredentials, ':')">
                <login>
                    <xsl:value-of select="substring-before($strCredentials, ':')"/>
                </login>
                <password>
                    <xsl:value-of select="substring-after($strCredentials, ':')"/>
                </password>
            </xsl:when>
            <xsl:otherwise>
                <login>
                    <xsl:value-of select="$strCredentials"/>
                </login>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- adm:qwerty@www.example.com:80 -->
    <xsl:function name="cpm:uriparse.addressGroup">
        <xsl:param name="strAddressGroup"/>

        <xsl:variable name="strAddress" select="substring-after($strAddressGroup, '//')"/>

        <xsl:choose>
            <xsl:when test="contains($strAddressGroup, '@')">
                <xsl:variable name="strCredentials" select="substring-before($strAddress, '@')"/>
                <xsl:copy-of select="cpm:uriparse.credentials($strCredentials)"/>
                <xsl:variable name="strHostPort" select="substring-after($strAddress, '@')"/>
                <xsl:copy-of select="cpm:uriparse.hostPort($strHostPort)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="cpm:uriparse.hostPort($strAddress)"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>

    <!-- adm:qwerty@www.example.com:80/zoo/animals/wombat.html?page=1&size=10#food -->
    <xsl:function name="cpm:uriparse.protocolRemain">
        <xsl:param name="strRemain"/>

        <xsl:variable name="strStart" select="cpm:regexp.start(cpm:urisyn.addressGroup())"/>

        <xsl:analyze-string select="$strRemain" regex="{$strStart}">
            <xsl:matching-substring>
                <xsl:copy-of select="cpm:uriparse.addressGroup(.)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:copy-of select="cpm:uriparse.localPathGroup(.)"/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>

    </xsl:function>

    <!-- http://adm:qwerty@www.example.com:80/zoo/animals/wombat.html?page=1&size=10#food -->
    <xsl:function name="cpm:uriparse.uri">
        <xsl:param name="strURI"/>

        <xsl:variable name="strStart" select="cpm:regexp.start(cpm:urisyn.fullProtocol())"/>

        <uri source="{$strURI}">
            <xsl:analyze-string select="$strURI" regex="{$strStart}">
                <xsl:matching-substring>
                    <protocol>
                        <xsl:value-of select="substring-before(., ':')"/>
                    </protocol>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:copy-of select="cpm:uriparse.protocolRemain(.)"/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </uri>

    </xsl:function>

</xsl:stylesheet>