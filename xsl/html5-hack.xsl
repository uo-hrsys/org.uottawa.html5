<!--
    @file brand.xsl
  
    Provide an extension point to the html5-hack plugin
  
    Copyright 2012, University of Ottawa 
   
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
  
    http://www.apache.org/licenses/LICENSE-2.0
  
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
  
 -->
<xsl:stylesheet version="2.0" xmlns:lang="http://www.w3.org/lang" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven" xmlns:enum="http://dita4publishers.org/enumerables"
  exclude-result-prefixes="df xs xsl lang mapdriven enum">

  <xsl:param name="HTML5OUTPUTLOCALBREADCRUMB" select="'TRUE'"/>

  <xsl:variable name="currentTopNavSection" select="/map/topicmeta/data[@name='currentTopNavSection']/@value"/>
  <xsl:variable name="outputDirectory" select="/map/topicmeta/data[@name='alternate-lang-directory']/@value"/>
  <xsl:variable name="lang" select="substring($TEMPLATELANG, 1, 2)"/>

  <!-- our templates used 2 digits lang -->
  <xsl:template match="*" mode="generate-html5-page">
    <html>
      <xsl:attribute name="lang" select="$lang"/>
      <xsl:attribute name="xml:lang" select="$lang"/>
      <xsl:apply-templates select="." mode="generate-head"/>
      <xsl:apply-templates select="." mode="generate-body"/>
    </html>
  </xsl:template>

  <!-- The following lines are a workarround to ouput central server side include to the university -->
  <xsl:template match="*" mode="gen-user-bottom-head">

    <xsl:comment>#include virtual="/assets-templates/3/inc/head-top-nojquery.html"</xsl:comment>
    <xsl:comment>#include virtual="/a/inc/main/head.php"</xsl:comment>
    <xsl:comment>#include virtual="/assets-templates/3/inc/head-bottom.html"</xsl:comment>

    <script>
		<xsl:attribute name="type">text/javascript</xsl:attribute>
		<xsl:text>var currentTopNavSection = "</xsl:text><xsl:value-of select="$currentTopNavSection"/><xsl:text>";</xsl:text>
    </script>

  </xsl:template>

  <!-- do not ouput the header -->
  <xsl:template match="*" mode="generate-header"/>

  <!-- top banner -->
  <xsl:template match="*" mode="include-uo-banner">
    <xsl:comment>#include virtual="/assets-templates/3/inc/banner-<xsl:value-of select="$lang"/>.html"</xsl:comment>
  </xsl:template>

  <!-- top banner -->
  <xsl:template match="*" mode="include-site-header">
    <xsl:comment>#include virtual="/a/inc/main/header-<xsl:value-of select="$lang"/>.php"</xsl:comment>
  </xsl:template>

  <!-- top navigation -->
  <xsl:template match="*" mode="include-site-top-navigation">
    <xsl:comment>#include virtual="/a/inc/main/top-navigation-<xsl:value-of select="$lang"/>.html"</xsl:comment>
  </xsl:template>

  <!-- site footer -->
  <xsl:template match="*" mode="include-uo-footer">
    <xsl:comment>#include virtual="/assets-templates/3/inc/footer-<xsl:value-of select="$lang"/>.html"</xsl:comment>
  </xsl:template>

  <!-- uo footer -->
  <xsl:template match="*" mode="include-site-footer">
    <xsl:comment>#include virtual="/a/inc/main/footer-<xsl:value-of select="$lang"/>.html"</xsl:comment>
  </xsl:template>

  <!-- generate main container -->
  <xsl:template match="*" mode="generate-main-container">
    <div role="application" id="{$IDMAINCONTAINER}">
      <xsl:sequence select="'&#x0a;'"/>
      <xsl:call-template name="gen-uo-page-links"/>
      <xsl:apply-templates select="." mode="include-uo-banner"/>
      <xsl:apply-templates select="." mode="generate-section-container"/>
    </div>
  </xsl:template>

  <!-- generate section container -->
  <xsl:template match="*" mode="generate-section-container">
    <div id="{$IDSECTIONCONTAINER}">
      <div id="wrapper" class="container">
        <xsl:apply-templates select="." mode="include-site-header"/>
        <xsl:apply-templates select="." mode="include-site-top-navigation"/>
        <xsl:apply-templates select="." mode="generate-main-content"/>
      </div>
      <xsl:apply-templates select="." mode="generate-footer"/>
    </div>
  </xsl:template>


  <!-- generate main container -->
  <xsl:template match="*" mode="generate-local-breadcrumbs">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    <xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes"/>
    <xsl:param name="documentation-title" as="xs:string" tunnel="yes"/>

    <xsl:variable name="id" select="./@id"/>
    <xsl:variable name="topicAncestors" select="$collected-data//*[@topicID=$id]/ancestor::*"/>

    <xsl:if test="$HTML5OUTPUTLOCALBREADCRUMB = 'TRUE'">
      <div id="toolbar">
        <div id="contentToolBar">
          <ul id="breadcrumbs">

            <li class="home">
              <a class="home" href="{concat($relativePath, 'index.html')}">
                <xsl:value-of select="$documentation-title"/>
              </a>
            </li>

            <xsl:for-each select="$topicAncestors">
              <xsl:if test="name(./*[1]) = 'title' and name(.) = 'topichead'">
                <li>
                  <xsl:variable name="name">
                    <xsl:choose>
                      <xsl:when test="./@origId">
                        <xsl:value-of select="'a'"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'span'"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:element name="{$name}">
                    <xsl:if test="./@origId">
                      <xsl:attribute name="href" select="concat($relativePath, '#', ./@origId)"/>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(./*[1])"/>
                  </xsl:element>
                </li>
              </xsl:if>
            </xsl:for-each>

          </ul>
        </div>
      </div>
    </xsl:if>
  </xsl:template>


  <!-- generate main content -->
  <xsl:template match="*" mode="generate-main-content">
    <xsl:param name="is-root" as="xs:boolean" tunnel="yes" select="false"/>
    <xsl:param name="content" tunnel="yes" as="node()*"/>
    <xsl:param name="navigation" as="element()*" tunnel="yes"/>
    <xsl:param name="documentation-title" tunnel="yes"/>
    <xsl:param name="audienceSelect" tunnel="yes"/>

    <div id="{$IDMAINCONTENT}" class="{$CLASSMAINCONTENT}">

      <xsl:sequence select="'&#x0a;'"/>

      <xsl:choose>
        <xsl:when test="$is-root">

          <div id="toolbar">
            <div id="homeToolBar">

              <!--xsl:value-of select="$documentation-title"/-->
              <xsl:sequence select="$audienceSelect"/>

            </div>
          </div>

          <xsl:sequence select="$navigation"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="generate-local-breadcrumbs"/>
        </xsl:otherwise>

      </xsl:choose>

      <div id="ajax-content">
        <xsl:choose>

          <xsl:when test="$is-root">
            <xsl:apply-templates select="." mode="set-initial-content"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- 
            	    !important
        		     if you remove section, you will need to change
        		     the d4p.property externalContentElement
        		-->
            <article>
              <xsl:sequence select="$content"/>
            </article>
          </xsl:otherwise>

        </xsl:choose>

      </div>

    </div>
  </xsl:template>


  <!-- generate footer -->
  <xsl:template match="*" mode="generate-footer">
    <div id="footer">
      <xsl:apply-templates select="." mode="include-site-footer"/>
      <xsl:apply-templates select="." mode="include-uo-footer"/>
    </div>
    <div id="section-closure"/>
  </xsl:template>

  <!-- redefine body class attribute -->
  <xsl:template match="*" mode="set-body-class-attr">
    <xsl:attribute name="class" select="concat(substring($TEMPLATELANG, 1, 2), ' ', 'theme-01', ' ', 'light')"/>
  </xsl:template>

  <xsl:template mode="generate-html5-nav-page-markup" match="*[df:class(.,'topic/title')][not(@toc = 'no')]"> </xsl:template>

  <!-- FIXME: the template should used params declared in ant instead of harcoding it here -->
  <xsl:template name="gen-uo-page-links">

    <xsl:param name="topicRelativeUri" tunnel="yes"/>
    <xsl:param name="result-uri" tunnel="yes"/>

    <xsl:variable name="uolang">
      <xsl:choose>
        <xsl:when test="$TEMPLATELANG='fr-ca'">
          <xsl:value-of select="'fr'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'en'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="opplang">
      <xsl:choose>
        <xsl:when test="$uolang='fr'">
          <xsl:value-of select="'en'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'fr'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="oppDomain">
      <xsl:choose>
        <xsl:when test="$uolang='fr'">
          <xsl:value-of select="'/en/'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'/fr/'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="oppLangName">

      <xsl:choose>
        <xsl:when test="$uolang='fr'">
          <xsl:value-of select="'English'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'Français'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="user-defined-alternate-lang" select="prolog/data[@name='alternate-language-id']/@value"/>

    <xsl:variable name="relativeUri">
      <xsl:choose>
        <xsl:when test="$user-defined-alternate-lang!=''">
          <xsl:value-of select="concat($outputDirectory, $user-defined-alternate-lang)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($outputDirectory, $topicRelativeUri)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <ul id="page-links">
      <li>
        <a id="skip-to-content" href="#{$IDMAINCONTENT}">
          <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'SkipToContent'"/>
          </xsl:call-template>
        </a>
      </li>
      <li>
        <a id="skip-to-localnav" href="#section-top">
          <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'SkipToLocalNav'"/>
          </xsl:call-template>
        </a>
      </li>

      <li>
        <a id="ch-lang-url" href="{concat($oppDomain, $relativeUri)}" lang="{$opplang}" hreflang="{$opplang}">
          <xsl:value-of select="$oppLangName"/>
        </a>
      </li>
    </ul>
  </xsl:template>


  <xsl:template mode="html5-impl" match="*"/>


</xsl:stylesheet>
