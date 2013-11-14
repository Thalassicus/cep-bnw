--·

INSERT OR REPLACE INTO Language_EN_US (Tag, Text, Gender, Plurality)
SELECT Tag, Text, Gender, Plurality
FROM Cep_Language_EN_US;

INSERT OR REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) 
SELECT Tag, Text, Gender, Plurality 
FROM Cep_Language_EN_US 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='DE_DE');	--· Default to English

INSERT OR REPLACE INTO Language_DE_DE(Tag, Text, Gender, Plurality) 
SELECT _local.Tag, _local.Text, _local.Gender, _local.Plurality 
FROM Cep_Language_EN_US _en, Cep_Language_DE_DE _local 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='DE_DE') 
AND (_local.Tag = _en.Tag AND _local.DateModified >= _en.DateModified);		--· Override with recent translation

INSERT OR REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) 
SELECT Tag, Text, Gender, Plurality 
FROM Cep_Language_EN_US 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='ES_ES');	--· Default to English

INSERT OR REPLACE INTO Language_ES_ES(Tag, Text, Gender, Plurality) 
SELECT _local.Tag, _local.Text, _local.Gender, _local.Plurality 
FROM Cep_Language_EN_US _en, Cep_Language_ES_ES _local 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='ES_ES') 
AND (_local.Tag = _en.Tag AND _local.DateModified >= _en.DateModified);		--· Override with recent translation

INSERT OR REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) 
SELECT Tag, Text, Gender, Plurality 
FROM Cep_Language_EN_US 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='FR_FR');	--· Default to English

INSERT OR REPLACE INTO Language_FR_FR(Tag, Text, Gender, Plurality) 
SELECT _local.Tag, _local.Text, _local.Gender, _local.Plurality 
FROM Cep_Language_EN_US _en, Cep_Language_FR_FR _local 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='FR_FR') 
AND (_local.Tag = _en.Tag AND _local.DateModified >= _en.DateModified);		--· Override with recent translation

INSERT OR REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) 
SELECT Tag, Text, Gender, Plurality 
FROM Cep_Language_EN_US 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='IT_IT');	--· Default to English

INSERT OR REPLACE INTO Language_IT_IT(Tag, Text, Gender, Plurality) 
SELECT _local.Tag, _local.Text, _local.Gender, _local.Plurality 
FROM Cep_Language_EN_US _en, Cep_Language_IT_IT _local 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='IT_IT') 
AND (_local.Tag = _en.Tag AND _local.DateModified >= _en.DateModified);		--· Override with recent translation

INSERT OR REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) 
SELECT Tag, Text, Gender, Plurality 
FROM Cep_Language_EN_US 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='JA_JP');	--· Default to English

INSERT OR REPLACE INTO Language_JA_JP(Tag, Text, Gender, Plurality) 
SELECT _local.Tag, _local.Text, _local.Gender, _local.Plurality 
FROM Cep_Language_EN_US _en, Cep_Language_JA_JP _local 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='JA_JP') 
AND (_local.Tag = _en.Tag AND _local.DateModified >= _en.DateModified);		--· Override with recent translation

INSERT OR REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) 
SELECT Tag, Text, Gender, Plurality 
FROM Cep_Language_EN_US 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='PL_PL');	--· Default to English

INSERT OR REPLACE INTO Language_PL_PL(Tag, Text, Gender, Plurality) 
SELECT _local.Tag, _local.Text, _local.Gender, _local.Plurality 
FROM Cep_Language_EN_US _en, Cep_Language_PL_PL _local 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='PL_PL') 
AND (_local.Tag = _en.Tag AND _local.DateModified >= _en.DateModified);		--· Override with recent translation

INSERT OR REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) 
SELECT Tag, Text, Gender, Plurality 
FROM Cep_Language_EN_US 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='RU_RU');	--· Default to English

INSERT OR REPLACE INTO Language_RU_RU(Tag, Text, Gender, Plurality) 
SELECT _local.Tag, _local.Text, _local.Gender, _local.Plurality 
FROM Cep_Language_EN_US _en, Cep_Language_RU_RU _local 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='RU_RU') 
AND (_local.Tag = _en.Tag AND _local.DateModified >= _en.DateModified);		--· Override with recent translation

INSERT OR REPLACE INTO Language_ZH_CN (Tag, Text, Gender, Plurality) 
SELECT Tag, Text, Gender, Plurality 
FROM Cep_Language_EN_US 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='ZH_CN');	--· Default to English

INSERT OR REPLACE INTO Language_ZH_CN(Tag, Text, Gender, Plurality) 
SELECT _local.Tag, _local.Text, _local.Gender, _local.Plurality 
FROM Cep_Language_EN_US _en, Cep_Language_ZH_CN _local 
WHERE EXISTS (SELECT * FROM Cep WHERE Type='LANGUAGE' AND Value='ZH_CN') 
AND (_local.Tag = _en.Tag AND _local.DateModified >= _en.DateModified);		--· Override with recent translation







UPDATE LoadedFile SET Value=1 WHERE Type='Cat_Language_End.sql';