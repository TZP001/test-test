KEY_TagID = step dateBegin dateEnd make makeError makeWarning systError mkmkFatal mkmkError mkmkErrorExtended mkmkWarning mkmkWarningExtended mkmkErrorWithId mkmkErrorExtendedWithId mkmkWarningWithId mkmkWarningExtendedWithId mkmkInfo cleanup CAAV5Error CAAV5Warning atpError atpWarning atpInfo
KEY_MsgID = stepStart stepEnd makeBegin makeEnd makeError makeWarning systError mkmkFatal mkmkError mkmkErrorExtended mkmkWarning mkmkWarningExtended mkmkErrorWithId mkmkErrorExtendedWithId mkmkWarningWithId mkmkWarningExtendedWithId mkmkInfo cleanup CAAV5Error CAAV5Warning atpError atpWarning atpInfo

# Name, Type(Simple, Complex), ListOfParameter
KEY_TagID_step_Name = Step
KEY_TagID_step_Type = Complex
KEY_TagID_step_ListOfParameter = Name

KEY_TagID_dateBegin_Name = DateBegin
KEY_TagID_dateBegin_Type = Simple
KEY_TagID_dateBegin_ListOfParameter = Value

KEY_TagID_dateEnd_Name = DateEnd
KEY_TagID_dateEnd_Type = Simple
KEY_TagID_dateEnd_ListOfParameter = Value

KEY_TagID_make_Name = Make
KEY_TagID_make_Type = Complex
KEY_TagID_make_ListOfParameter = BuildStep Framework Module Extend File

KEY_TagID_makeError_Name = MakeError
KEY_TagID_makeError_Type = Simple
KEY_TagID_makeError_ListOfParameter = File

KEY_TagID_makeWarning_Name = MakeWarning
KEY_TagID_makeWarning_Type = Simple
KEY_TagID_makeWarning_ListOfParameter = File

KEY_TagID_systError_Name = SystError
KEY_TagID_systError_Type = Simple
KEY_TagID_systError_ListOfParameter = Value_1 Value_2

KEY_TagID_mkmkFatal_Name = MkmkFatal
KEY_TagID_mkmkFatal_Type = Simple
KEY_TagID_mkmkFatal_ListOfParameter = Value

KEY_TagID_mkmkError_Name = MkmkError
KEY_TagID_mkmkError_Type = Simple
KEY_TagID_mkmkError_ListOfParameter = Value

KEY_TagID_mkmkErrorExtended_Name = MkmkError
KEY_TagID_mkmkErrorExtended_Type = Simple
KEY_TagID_mkmkErrorExtended_ListOfParameter = Value Framework Module

KEY_TagID_mkmkWarning_Name = MkmkWarning
KEY_TagID_mkmkWarning_Type = Simple
KEY_TagID_mkmkWarning_ListOfParameter = Value

KEY_TagID_mkmkWarningExtended_Name = MkmkWarning
KEY_TagID_mkmkWarningExtended_Type = Simple
KEY_TagID_mkmkWarningExtended_ListOfParameter = Value Framework Module

KEY_TagID_mkmkErrorWithId_Name = MkmkError
KEY_TagID_mkmkErrorWithId_Type = Simple
KEY_TagID_mkmkErrorWithId_ListOfParameter = Id Value

KEY_TagID_mkmkErrorExtendedWithId_Name = MkmkError
KEY_TagID_mkmkErrorExtendedWithId_Type = Simple
KEY_TagID_mkmkErrorExtendedWithId_ListOfParameter = Id Value Framework Module

KEY_TagID_mkmkWarningWithId_Name = MkmkWarning
KEY_TagID_mkmkWarningWithId_Type = Simple
KEY_TagID_mkmkWarningWithId_ListOfParameter = Id Value

KEY_TagID_mkmkWarningExtendedWithId_Name = MkmkWarning
KEY_TagID_mkmkWarningExtendedWithId_Type = Simple
KEY_TagID_mkmkWarningExtendedWithId_ListOfParameter = Id Value Framework Module

KEY_TagID_mkmkMessage_Name = MkmkMessage
KEY_TagID_mkmkMessage_Type = Simple
KEY_TagID_mkmkMessage_ListOfParameter = Value

KEY_TagID_mkmkInfo_Name = MkmkInfo
KEY_TagID_mkmkInfo_Type = Simple
KEY_TagID_mkmkInfo_ListOfParameter = Value

KEY_TagID_cleanup_Name = Cleanup
KEY_TagID_cleanup_Type = Simple
KEY_TagID_cleanup_ListOfParameter = BuildStep File

KEY_TagID_CAAV5Error_Name = CAAV5Error
KEY_TagID_CAAV5Error_Type = Simple
KEY_TagID_CAAV5Error_ListOfParameter = Value

KEY_TagID_CAAV5Warning_Name = CAAV5Warning
KEY_TagID_CAAV5Warning_Type = Simple
KEY_TagID_CAAV5Warning_ListOfParameter = Value

KEY_TagID_atpError_Name = AtpError
KEY_TagID_atpError_Type = Simple
KEY_TagID_atpError_ListOfParameter = EntryPoint Framework Type Value

KEY_TagID_atpWarning_Name = AtpWarning
KEY_TagID_atpWarning_Type = Simple
KEY_TagID_atpWarning_ListOfParameter = EntryPoint Framework Type Value

KEY_TagID_atpInfo_Name = AtpInfo
KEY_TagID_atpInfo_Type = Simple
KEY_TagID_atpInfo_ListOfParameter = Value

# TagMode -> null = 0, open = 1, close = 2
# TagMapping -> from 0 to n for Simple and open Complex

KEY_MsgID_stepStart_ListOfTagID = step dateBegin
KEY_MsgID_stepStart_ListOfTagMode = 1 0
KEY_MsgID_stepStart_ListOfTagMapping = 0 1

KEY_MsgID_stepEnd_ListOfTagID = dateEnd step
KEY_MsgID_stepEnd_ListOfTagMode = 0 2
KEY_MsgID_stepEnd_ListOfTagMapping = 1

KEY_MsgID_makeBegin_ListOfTagID = make
KEY_MsgID_makeBegin_ListOfTagMode = 1
KEY_MsgID_makeBegin_ListOfTagMapping = 0 1 2 5 3

KEY_MsgID_makeEnd_ListOfTagID = make
KEY_MsgID_makeEnd_ListOfTagMode = 2

KEY_MsgID_makeError_ListOfTagID = makeError
KEY_MsgID_makeError_ListOfTagMode = 0
KEY_MsgID_makeError_ListOfTagMapping = 4

KEY_MsgID_makeWarning_ListOfTagID = makeWarning
KEY_MsgID_makeWarning_ListOfTagMode = 0
KEY_MsgID_makeWarning_ListOfTagMapping = 4

KEY_MsgID_systError_ListOfTagID = systError
KEY_MsgID_systError_ListOfTagMode = 0
KEY_MsgID_systError_ListOfTagMapping = 0 1

KEY_MsgID_mkmkFatal_ListOfTagID = mkmkFatal
KEY_MsgID_mkmkFatal_ListOfTagMode = 0
KEY_MsgID_mkmkFatal_ListOfTagMapping = 0

KEY_MsgID_mkmkError_ListOfTagID = mkmkError
KEY_MsgID_mkmkError_ListOfTagMode = 0
KEY_MsgID_mkmkError_ListOfTagMapping = 0

KEY_MsgID_mkmkErrorExtended_ListOfTagID = mkmkErrorExtended
KEY_MsgID_mkmkErrorExtended_ListOfTagMode = 0
KEY_MsgID_mkmkErrorExtended_ListOfTagMapping = 0 1 2

KEY_MsgID_mkmkWarning_ListOfTagID = mkmkWarning
KEY_MsgID_mkmkWarning_ListOfTagMode = 0
KEY_MsgID_mkmkWarning_ListOfTagMapping = 0

KEY_MsgID_mkmkWarningExtended_ListOfTagID = mkmkWarningExtended
KEY_MsgID_mkmkWarningExtended_ListOfTagMode = 0
KEY_MsgID_mkmkWarningExtended_ListOfTagMapping = 0 1 2

KEY_MsgID_mkmkErrorWithId_ListOfTagID = mkmkErrorWithId
KEY_MsgID_mkmkErrorWithId_ListOfTagMode = 0
KEY_MsgID_mkmkErrorWithId_ListOfTagMapping = 0 1

KEY_MsgID_mkmkErrorExtendedWithId_ListOfTagID = mkmkErrorExtendedWithId
KEY_MsgID_mkmkErrorExtendedWithId_ListOfTagMode = 0
KEY_MsgID_mkmkErrorExtendedWithId_ListOfTagMapping = 0 1 2 3

KEY_MsgID_mkmkWarningWithId_ListOfTagID = mkmkWarningWithId
KEY_MsgID_mkmkWarningWithId_ListOfTagMode = 0
KEY_MsgID_mkmkWarningWithId_ListOfTagMapping = 0 1

KEY_MsgID_mkmkWarningExtendedWithId_ListOfTagID = mkmkWarningExtendedWithId
KEY_MsgID_mkmkWarningExtendedWithId_ListOfTagMode = 0
KEY_MsgID_mkmkWarningExtendedWithId_ListOfTagMapping = 0 1 2 3

KEY_MsgID_mkmkInfo_ListOfTagID = mkmkInfo
KEY_MsgID_mkmkInfo_ListOfTagMode = 0
KEY_MsgID_mkmkInfo_ListOfTagMapping = 0

KEY_MsgID_cleanup_ListOfTagID = cleanup
KEY_MsgID_cleanup_ListOfTagMode = 0
KEY_MsgID_cleanup_ListOfTagMapping = 0 1

KEY_MsgID_CAAV5Error_ListOfTagID = CAAV5Error
KEY_MsgID_CAAV5Error_ListOfTagMode = 0
KEY_MsgID_CAAV5Error_ListOfTagMapping = 0

KEY_MsgID_CAAV5Warning_ListOfTagID = CAAV5Warning
KEY_MsgID_CAAV5Warning_ListOfTagMode = 0
KEY_MsgID_CAAV5Warning_ListOfTagMapping = 0

KEY_MsgID_atpError_ListOfTagID = atpError
KEY_MsgID_atpError_ListOfTagMode = 0
KEY_MsgID_atpError_ListOfTagMapping = 0 1 2 3

KEY_MsgID_atpWarning_ListOfTagID = atpWarning
KEY_MsgID_atpWarning_ListOfTagMode = 0
KEY_MsgID_atpWarning_ListOfTagMapping = 0 1 2 3

KEY_MsgID_atpInfo_ListOfTagID = atpInfo
KEY_MsgID_atpInfo_ListOfTagMode = 0
KEY_MsgID_atpInfo_ListOfTagMapping = 0

