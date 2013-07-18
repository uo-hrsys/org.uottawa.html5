<xsl:stylesheet 
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  exclude-result-prefixes="df xs relpath htmlutil xd dc"
  version="2.0">

  <xsl:param name="HTML5OUTPUTLOCALBREADCRUMB" select="'TRUE'"/>
  <xsl:param name="UOHRASSETSDOMAIN" select="'/'"/>

  <xsl:variable name="currentTopNavSection" select="/map/topicmeta/data[@name='currentTopNavSection'][1]/@value"/>
  <xsl:variable name="outputDirectory" select="/map/topicmeta/data[@name='alternate-lang-directory'][1]/@value"/>
  <xsl:variable name="lang" select="substring($TEMPLATELANG, 1, 2)"/>
  
  <xsl:variable name="alternate-domain">
   <xsl:choose>
        <xsl:when test="$lang='fr'">
          <xsl:value-of select="'http://www.hr.uottawa.ca/'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'http://www.rh.uottawa.ca/'"/>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:variable>

  <!-- our templates used 2 digits lang -->
  <xsl:template match="*" mode="generate-html5-page">
    <html>
      <xsl:attribute name="lang" select="$lang"/>
      <xsl:apply-templates select="." mode="generate-head"/>
      <xsl:apply-templates select="." mode="generate-body"/>
    </html>
  </xsl:template>

  <!-- The following lines are a workarround to ouput central server side include to the university -->



  <xsl:template match="*" mode="gen-user-top-head">
  
    <meta name="alternate-lang-directory" content="{$outputDirectory}" />
    <meta name="alternate-domain" content="{$alternate-domain}" />
    
    <xsl:comment>#include virtual="/a/inc/main/head.php"</xsl:comment>
    <script type="text/javascript" src="{concat($UOHRASSETSDOMAIN, 'a/js/employee-group.js')}"/>
  </xsl:template>


  <xsl:template match="*" mode="gen-user-bottom-head">

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
          <xsl:value-of select="'http://www.hr.uottawa.ca/'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'http://www.rh.uottawa.ca/'"/>
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

    <xsl:message> relativeUri : <xsl:value-of select="$topicRelativeUri"/> user-defined-alternate-lang: <xsl:value-of
        select="$user-defined-alternate-lang"/>
    </xsl:message>

    <xsl:variable name="relativeUri">
      <xsl:choose>
        <xsl:when test="$user-defined-alternate-lang!=''">
          <!--xsl:value-of select="concat($outputDirectory, $user-defined-alternate-lang)"/-->
          <xsl:value-of select="concat($outputDirectory, $topicRelativeUri)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($outputDirectory, $topicRelativeUri)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div id="skip-links">
     <a class="skip-link" href="#main-content"> <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'SkipToContent'"/>
          </xsl:call-template></a>
     <a class="skip-link" href="#section-top"> <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'SkipToLocalNav'"/>
          </xsl:call-template></a>
     <a class="skip-link" href="#footer"> <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'SkipToFooter'"/>
          </xsl:call-template></a>
	</div>  
    <ul id="page-links">
      <li>
        <a id="ch-lang-url" href="{concat($oppDomain, $relativeUri)}" lang="{$opplang}" hreflang="{$opplang}">
          <xsl:value-of select="$oppLangName"/>
        </a>
      </li>
    </ul>
  </xsl:template>


  <xsl:template mode="html5-impl" match="*"/>

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-audience-select">
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
    <xsl:message> + [INFO] Generating audience select </xsl:message>

    <span id="audience-widget">
      <button id="audienceBtn">
        <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'chooseAudience'"/>
        </xsl:call-template>
      </button>
    </span>
    <div id="audience-list" class="with-shadow">
      <div id="group-links">
        <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]" mode="generate-audience-select"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="*" mode="generate-audience-select">
    <xsl:apply-templates select="*" mode="generate-audience-select"/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/audience ')]" mode="generate-audience-select">
    <xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes"/>
    <xsl:message> + [INFO] Generating audience <xsl:value-of select="@name"/> entry </xsl:message>

    <xsl:variable name="selected">
      <xsl:choose>
        <xsl:when test="@name = $activeAudience">
          <xsl:value-of select="'selected'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'not-selected'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <a href="{concat($relativePath, $indexUri, '/../../', @name, '/')}"
      class="{concat('d4p-no-ajax ', 'group-link ', $selected)}">

      <div class="span-4 prepend-top">
        <div class="box square with-outset with-large-radius">
          <div id="{@name}" role="button" class="choose-group-button">
            <h2>
              <xsl:value-of select="@othertype"/>
            </h2>
            <xsl:if test="@otherjob!=''">
              <abbr title="{@othertype}">
                <xsl:value-of select="@otherjob"/>
              </abbr>
            </xsl:if>

          </div>
        </div>
      </div>

    </a>

  </xsl:template>






</xsl:stylesheet>
