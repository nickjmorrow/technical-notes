

ALTER PROCEDURE [dbo].[TRS_Underwriting_UWDealDuplicateCheck]    
 @UpdateFoundDuplicates BIT=0    
    ,@UWDealID AS INT    
 ,@encryptedTaxID_SSN NVARCHAR(50)=NULL    
 ,@encryptedTaxID_EIN NVARCHAR(50)=NULL    
 ,@encryptedPOTaxID_SSN NVARCHAR(50)=NULL    
 ,@encryptedPOTaxID_EIN NVARCHAR(50)=NULL    
 ,@encryptedSOTaxID_SSN NVARCHAR(50)=NULL    
 ,@encryptedSOTaxID_EIN NVARCHAR(50)=NULL    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
/* Variables*/    
DECLARE @dealID INT    
DECLARE @merchantID INT     
DECLARE @companyName NVARCHAR(500)    
DECLARE @companyLegalName NVARCHAR(500)    
DECLARE @State NVARCHAR(50)    
DECLARE @BusinessPhoneNumber NVARCHAR(500)    
DECLARE @FaxPhoneNumber NVARCHAR(500)    
DECLARE @POPhoneNumber NVARCHAR(500)    
DECLARE @SOPhoneNumber NVARCHAR(500)     
DECLARE @DuplicateStatus INT    
    
IF OBJECT_ID('tempdb..#DuplicateDeals') IS NOT NULL    
        DROP TABLE #DuplicateDeals;    
    
CREATE TABLE #DuplicateDeals     
(    
 DealID INT    
 ,UWDealID INT    
 ,CompanyName NVARCHAR(250) NULL    
 ,CompanyLegalName NVARCHAR(250) NULL    
 ,BusinessPhone NVARCHAR(50) NULL    
 ,BusinessFax NVARCHAR(50) NULL    
 ,PrimaryOwnerFirstName NVARCHAR(50)    
 ,PrimaryOwnerLastName NVARCHAR(50)    
 ,POPhone NVARCHAR(50) NULL    
 ,SecondaryOwnerFirstName NVARCHAR(50)    
 ,SecondaryOwnerLastName NVARCHAR(50)    
 ,SOPhone NVARCHAR(50) NULL    
 ,DuplicateStatus INT    
 ,encryptedBusinessTaxID NVARCHAR(50) NULL    
 ,encryptedPOTaxID  NVARCHAR(50) NULL    
 ,encryptedSOTaxID  NVARCHAR(50) NULL    
 ,MerchantID INT    
 ,Created DATETIME    
 ,DealStatusID INT    
    ,UWDealStatus INT     
 ,SRFirstName NVARCHAR(350)    
 ,SRLastName NVARCHAR(350)    
 ,POFirstName NVARCHAR(100)    
 ,POLastName NVARCHAR(100)    
 ,SOFirstName NVARCHAR(100)    
 ,SOLastName NVARCHAR(100)    
 ,ISOCompany NVARCHAR(350)    
 ,Reason NVARCHAR(500) NULL    
 ,DealDateEnded DATETIME NULL    
)    
    
/* Bitmask*/    
DECLARE @flag INT=1    
DECLARE @bitwiseCompanyName INT =2048    
DECLARE @bitwiseBusinessPhone INT =8192    
DECLARE @bitwiseOwnerPhone INT =4096    
DECLARE @bitwiseBusinessTaxId INT =32768    
DECLARE @bitwiseOwnerTaxId INT =16384    
    
SELECT @dealID = uwd.DealID, @State=m.state FROM dbo.TRS_Underwriting_Deals uwd JOIN dbo.TRS_Deals d ON d.NumericID = uwd.DealID JOIN dbo.TRS_Merchants m ON m.NumericID = d.MerchantID WHERE uwd.NumericID=@UWDealID    
SELECT @companyName='%'+REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(origM.CompanyName,'%','[%]'),' ','%'),'-','%'),'''','%'),'(',''),')',''),'#','%'),',','%'),'%%','%')+'%'     
,@companyLegalName='%'+REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(origM.CompanyLegalName,'%','[%]'),' ','%'),'-','%'),'''','%'),'(',''),')',''),'#','%'),',','%'),'%%','%')+'%'     
,@BusinessPhoneNumber = origM.PhoneNumber1
,@FaxPhoneNumber = origM.FaxNumber
,@POPhoneNumber = po.PhoneNumber1     
,@SOPhoneNumber = so.PhoneNumber1   
,@merchantID = origdeal.MerchantID    
FROM dbo.TRS_Deals origdeal     
JOIN dbo.TRS_Merchants origM ON origM.NumericID = origdeal.MerchantID    
JOIN dbo.TRS_BusinessPersons po ON po.NumericID = origM.PrimaryOwnerID    
JOIN dbo.TRS_BusinessPersons so ON so.NumericID = origM.SecondaryOwnerID    
WHERE origdeal.NumericID=@dealID    
    
IF (LEN(REPLACE(@BusinessPhoneNumber,'%', '')) = 0)    
BEGIN    
 SELECT @BusinessPhoneNumber = null    
END    
IF (LEN(REPLACE(@FaxPhoneNumber,'%', '')) = 0)    
BEGIN    
 SELECT @FaxPhoneNumber = null    
END    
    
IF (LEN(REPLACE(@POPhoneNumber,'%', '')) = 0)    
BEGIN    
 SELECT @POPhoneNumber = null    
END    
    
IF (LEN(REPLACE(@SOPhoneNumber,'%', '')) = 0)    
BEGIN    
 SELECT @SOPhoneNumber = null    
END    
    
INSERT INTO #DuplicateDeals(DealID,UWDealID,MerchantID,CompanyName,CompanyLegalName,BusinessPhone,BusinessFax,POPhone,SOPhone, encryptedBusinessTaxID, encryptedPOTaxID, encryptedSOTaxID, Created, DealStatusID, UWDealStatus,SRFirstName, SRLastName,  POFirstName,POLastName,SOFirstName,SOLastName,ISOCompany, DealDateEnded)    
SELECT d.NumericID,uwd.NumericID, d.MerchantID, m.CompanyName, m.CompanyLegalName,m.PhoneNumber1,m.FaxNumber,po.PhoneNumber1,so.PhoneNumber1, m.TaxID, po.TaxID, so.TaxID, d.Created, d.DealStatusID, uwd.UWDealStatus,  sr.FirstName ,sr.LastName,po.FirstName
  
,po.LastName,so.FirstName,so.LastName,iso.IndependentSalesOffice, d.DateEnded    
FROM     
dbo.TRS_Deals d     
JOIN dbo.TRS_Underwriting_Deals uwd ON uwd.DealID = d.NumericID    
JOIN dbo.TRS_Merchants m ON m.NumericID = d.MerchantID    
JOIN dbo.TRS_BusinessPersons po ON po.NumericID = m.PrimaryOwnerID    
JOIN dbo.TRS_BusinessPersons so ON so.NumericID = m.SecondaryOwnerID    
LEFT JOIN dbo.TRS_SalesRepresentatives sr ON sr.NumericID = d.SalesRepresentativeID    
LEFT JOIN dbo.TRS_SalesRepresentatives iso ON iso.NumericID = COALESCE(sr.ParentISOID, sr.NumericID)    
--JOIN dbo.TRS_Underwriting_UWDealStatuses uwstatus ON uwstatus.NumericID = uwd.UWDealStatus    
--LEFT JOIN dbo.TRS_MerchantNotes mn ON mn.DealID = d.NumericID AND mn.NoteEventID=4 AND mn.DealStatusID=2 AND d.DealStatusID IN (2,3)    
WHERE     
d.NumericID <>@dealID AND d.MerchantID<>@merchantID AND     
(    
 (( m.State=@State OR m.State IS NULL) AND (m.CompanyName LIKE @companyName OR m.CompanyLegalName LIKE @companyName OR m.CompanyName LIKE @CompanyLegalName OR m.CompanyLegalName LIKE @CompanyLegalName) )    
    
 OR ((@BusinessPhoneNumber IS NOT NULL)     
  AND  (m.PhoneNumber1 = @BusinessPhoneNumber    
   OR m.FaxNumber = @BusinessPhoneNumber    
   OR po.PhoneNumber1 = @BusinessPhoneNumber    
   OR so.PhoneNumber1 = @BusinessPhoneNumber))    
    
 OR ((@FaxPhoneNumber IS NOT NULL)    
   AND (m.PhoneNumber1 = @FaxPhoneNumber    
    OR m.FaxNumber = @FaxPhoneNumber    
    OR po.PhoneNumber1 = @FaxPhoneNumber    
    OR so.PhoneNumber1 = @FaxPhoneNumber))    
    
 OR ((@POPhoneNumber IS NOT NULL)    
  AND (m.PhoneNumber1 = @POPhoneNumber    
   OR m.FaxNumber = @POPhoneNumber    
   OR po.PhoneNumber1 = @POPhoneNumber    
   OR so.PhoneNumber1 = @POPhoneNumber))    
    
 OR ((@SOPhoneNumber IS NOT NULL)    
  AND (m.PhoneNumber1 = @SOPhoneNumber    
   OR m.FaxNumber = @SOPhoneNumber    
   OR po.PhoneNumber1 = @SOPhoneNumber    
   OR so.PhoneNumber1 = @SOPhoneNumber))       
    
 OR ((@encryptedTaxID_SSN IS NOT NULL)    
  AND (m.TaxID = @encryptedTaxID_SSN    
   OR po.TaxID = @encryptedTaxID_SSN    
   OR so.TaxID = @encryptedTaxID_SSN))    
    
 OR ((@encryptedTaxID_EIN IS NOT NULL)    
  AND (m.TaxID = @encryptedTaxID_EIN    
   OR po.TaxID = @encryptedTaxID_EIN    
   OR so.TaxID = @encryptedTaxID_EIN))      
    
 OR ((@encryptedPOTaxID_SSN IS NOT NULL)    
  AND (m.TaxID = @encryptedPOTaxID_SSN    
   OR po.TaxID = @encryptedPOTaxID_SSN       
   OR so.TaxID = @encryptedPOTaxID_SSN))    
    
 OR ((@encryptedPOTaxID_EIN IS NOT NULL)    
  AND (m.TaxID = @encryptedPOTaxID_EIN    
   OR po.TaxID = @encryptedPOTaxID_EIN    
   OR so.TaxID = @encryptedPOTaxID_EIN))    
    
 OR ((@encryptedSOTaxID_SSN IS NOT NULL)    
  AND (m.TaxID = @encryptedSOTaxID_SSN    
   OR po.TaxID = @encryptedSOTaxID_SSN    
   OR so.TaxID = @encryptedSOTaxID_SSN))    
    
 OR ((@encryptedSOTaxID_EIN IS NOT NULL)    
  AND (m.TaxID = @encryptedSOTaxID_EIN     
   OR po.TaxID = @encryptedSOTaxID_EIN     
   OR so.TaxID = @encryptedSOTaxID_EIN ))    
)    
    
UPDATE #DuplicateDeals SET Reason=ISNULL(Reason,'')+'Company Name, '    
WHERE (CompanyName LIKE @companyName OR CompanyLegalName LIKE @companyName OR CompanyName LIKE @CompanyLegalName OR CompanyLegalName LIKE @CompanyLegalName)    
    
UPDATE #DuplicateDeals SET Reason=ISNULL(Reason,'')+'Business Phone Number, '    
WHERE BusinessPhone = @BusinessPhoneNumber    
 OR BusinessPhone = @FaxPhoneNumber    
 OR BusinessPhone = @POPhoneNumber    
 OR BusinessPhone = @SOPhoneNumber    
 OR BusinessFax = @BusinessPhoneNumber    
 OR BusinessFax = @FaxPhoneNumber    
 OR BusinessFax = @POPhoneNumber    
 OR BusinessFax = @SOPhoneNumber    
    
UPDATE #DuplicateDeals SET Reason=ISNULL(Reason,'')+'Owner''s Phone Number, '    
WHERE POPhone = @BusinessPhoneNumber    
 OR POPhone = @FaxPhoneNumber    
 OR POPhone = @POPhoneNumber    
 OR POPhone = @SOPhoneNumber    
 OR SOPhone = @BusinessPhoneNumber    
 OR SOPhone = @FaxPhoneNumber    
 OR SOPhone = @POPhoneNumber    
 OR SOPhone = @SOPhoneNumber    
    
UPDATE #DuplicateDeals SET Reason=ISNULL(Reason,'')+'Business Tax ID, '    
WHERE encryptedBusinessTaxID = @encryptedTaxID_SSN    
 OR encryptedBusinessTaxID = @encryptedTaxID_EIN    
 OR encryptedBusinessTaxID = @encryptedPOTaxID_SSN    
 OR encryptedBusinessTaxID = @encryptedPOTaxID_EIN    
 OR encryptedBusinessTaxID = @encryptedSOTaxID_SSN    
 OR encryptedBusinessTaxID = @encryptedSOTaxID_EIN    
    
    
UPDATE #DuplicateDeals    
SET Reason=ISNULL(Reason,'')+'Owner''s Tax ID, '    
WHERE encryptedPOTaxID = @encryptedTaxID_SSN /* Primary Owner's Tax ID*/    
 OR encryptedPOTaxID = @encryptedTaxID_EIN    
 OR encryptedPOTaxID = @encryptedPOTaxID_SSN    
 OR encryptedPOTaxID = @encryptedPOTaxID_EIN    
 OR encryptedPOTaxID = @encryptedSOTaxID_SSN    
 OR encryptedPOTaxID = @encryptedSOTaxID_EIN    
     
 OR encryptedSOTaxID = @encryptedTaxID_SSN  /* Secondary Owner's Tax ID*/    
 OR encryptedSOTaxID = @encryptedTaxID_EIN    
 OR encryptedSOTaxID = @encryptedPOTaxID_SSN    
 OR encryptedSOTaxID = @encryptedPOTaxID_EIN    
 OR encryptedSOTaxID = @encryptedSOTaxID_SSN    
 OR encryptedSOTaxID = @encryptedSOTaxID_EIN    
    
UPDATE #DuplicateDeals SET @DuplicateStatus=ISNULL(@DuplicateStatus,@flag)|@bitwiseCompanyName WHERE Reason LIKE '%Company Name%'     
UPDATE #DuplicateDeals SET @DuplicateStatus=ISNULL(@DuplicateStatus,@flag)|@bitwiseBusinessPhone WHERE Reason LIKE '%Business Phone Number%'    
UPDATE #DuplicateDeals SET @DuplicateStatus=ISNULL(@DuplicateStatus,@flag)|@bitwiseOwnerPhone WHERE Reason LIKE '%Owner''s Phone Number%'    
UPDATE #DuplicateDeals SET @DuplicateStatus=ISNULL(@DuplicateStatus,@flag)|@bitwiseBusinessTaxId WHERE Reason LIKE '%Business Tax ID%'    
UPDATE #DuplicateDeals SET @DuplicateStatus=ISNULL(@DuplicateStatus,@flag)|@bitwiseOwnerTaxId WHERE Reason LIKE '%Owner''s Tax ID%'    
    
/* remove last comma */    
UPDATE #DuplicateDeals SET Reason=SUBSTRING(Reason,1,LEN(Reason)-1) WHERE Reason IS NOT NULL    
--UPDATE @DuplicateDeals SET DaysLeftOfExclusivity=0 WHERE DaysLeftOfExclusivity<0    
    
IF (@updateFoundDuplicates=1)    
BEGIN    
 UPDATE uwd SET uwd.DuplicateStatus=@DuplicateStatus FROM dbo.TRS_Underwriting_Deals uwd JOIN #DuplicateDeals dd ON dd.UWDealID=uwd.NumericID WHERE (uwd.DuplicateCheckDone=1 AND uwd.DuplicateStatus IS NULL) OR (uwd.IsRenewal=1)    
 UPDATE uwd SET uwd.DuplicateStatus=@DuplicateStatus, uwd.DuplicateCheckDone=1 FROM dbo.TRS_Underwriting_Deals uwd WHERE uwd.NumericID=@UWDealID    
END    
    
/* RETURN dataset */    
SELECT * FROM #DuplicateDeals ORDER BY Created DESC    
 