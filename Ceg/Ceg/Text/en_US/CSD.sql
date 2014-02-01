--· EN_US/CSD.sql

INSERT INTO Cep
(Type, Value)
SELECT 'SkipFile', 'CSD.sql'
WHERE EXISTS (SELECT Value FROM Cep WHERE Type='USING_CSD' AND Value= 0 );

INSERT INTO Cep_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-20'), 'TXT_KEY_POLICY_PHILANTHROPY_HELP_EXTRA', '[NEWLINE]+1 [ICON_HAPPINESS_1] City Happiness from Schools of Scribes', '', '');
--INSERT INTO Cep_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-20'), 'TXT_KEY_POLICY_CULTURAL_DIPLOMACY_HELP_EXTRA', '[NEWLINE]+3 [ICON_CULTURE] Culture from Foreign Office', '', '');
--INSERT INTO Cep_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-20'), 'TXT_KEY_POLICY_AESTHETICS_HELP_EXTRA', '[NEWLINE]+20% [ICON_GOLD] Gold from Gutenberg Press', '', '');
--INSERT INTO Cep_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-20'), 'TXT_KEY_POLICY_SCHOLASTICISM_HELP_EXTRA', '[NEWLINE]+10% [ICON_RESEARCH] Science from Postal Services', '', '');
--INSERT INTO Cep_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-20'), 'TXT_KEY_POLICY_TRADE_PACT_HELP_EXTRA', '[NEWLINE]+2 Envoys', '', '');



UPDATE LoadedFile SET Value=1 WHERE Type='CEP_CSD.sql';
