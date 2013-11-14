--· EN_US/CSD.sql

-- Can't have WHERE clause in INSERT statement?
--INSERT INTO CEP (Type, Value) VALUES ('SkipFile', 'CSD.sql') WHERE NOT EXISTS (SELECT * FROM CEP WHERE Type = 'USING_CSD' AND Value = 1);
INSERT INTO CEP_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-20'), 'TXT_KEY_POLICY_PHILANTHROPY_HELP_EXTRA', '[NEWLINE]+1 [ICON_HAPPINESS_1] City Happiness from Schools of Scribes', '', '');
INSERT INTO CEP_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-20'), 'TXT_KEY_POLICY_CULTURAL_DIPLOMACY_HELP_EXTRA', '[NEWLINE]+3 [ICON_CULTURE] Culture from Foreign Office', '', '');
INSERT INTO CEP_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-20'), 'TXT_KEY_POLICY_AESTHETICS_HELP_EXTRA', '[NEWLINE]+20% [ICON_GOLD] Gold from Gutenberg Press', '', '');
INSERT INTO CEP_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-20'), 'TXT_KEY_POLICY_SCHOLASTICISM_HELP_EXTRA', '[NEWLINE]+10% [ICON_RESEARCH] Science from Postal Services', '', '');
INSERT INTO CEP_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-20'), 'TXT_KEY_POLICY_TRADE_PACT_HELP_EXTRA', '[NEWLINE]+2 Envoys', '', '');



UPDATE LoadedFile SET Value=1 WHERE Type='CSD.sql';
