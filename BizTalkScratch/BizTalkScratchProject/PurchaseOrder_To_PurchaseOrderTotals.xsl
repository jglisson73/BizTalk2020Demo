<?xml version="1.0" encoding="UTF-16"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var" version=".0"
                xmlns:ns0="http://BizTalkScratchProject.PurchaseOrder">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    
    <!--Root PurchaseOrder element-->
    <xsl:element name="ns0:PurchaseOrder">
      <xsl:element name="CustomerNumber">
        <xsl:value-of select="/*[local-name()='PurchaseOrder']/*[local-name()='CustomerNumber']"/>
      </xsl:element>
      <xsl:element name="PONumber">
        <xsl:value-of select="/*[local-name()='PurchaseOrder']/*[local-name()='PONumber']"/>
      </xsl:element>
      <xsl:element name="OrderDate">
        <xsl:value-of select="/*[local-name()='PurchaseOrder']/*[local-name()='OrderDate']"/>
      </xsl:element>

      <!--OrderLine elements-->
      <xsl:for-each select="/*[local-name()='PurchaseOrder']/*[local-name()='OrderLine']">
        <xsl:element name="OrderLine">
          <xsl:element name="ProductNumber">
            <xsl:value-of select="./*[local-name()='ProductNumber']"/>
          </xsl:element>
          <xsl:element name="Quantity">
            <xsl:value-of select="./*[local-name()='Quantity']"/>
          </xsl:element>
          <xsl:element name="Amount">
            <xsl:value-of select="./*[local-name()='Amount']"/>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!--ProductTotalOrdered aggregation-->
      <xsl:for-each-group select="/*[local-name()='PurchaseOrder']/*[local-name()='OrderLine']" group-by="*[local-name()='ProductNumber']">
        <xsl:element name="ProductTotalOrdered">
          <xsl:element name="ProductNumber">
            <xsl:value-of select="./*[local-name()='ProductNumber']"/>
          </xsl:element>
          <xsl:element name="Quantity">
            <xsl:value-of select="sum(current-group()/*[local-name()='Quantity'])"/>
          </xsl:element>
        </xsl:element>
      </xsl:for-each-group>      
      
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>