*** Settings ***
Documentation          This suite is for testing SEL time in Open BMC.

Resource        ../lib/ipmi_client.robot

Library                 OperatingSystem
Library                 SSHLibrary
Library                 DateTime

Suite Setup             Open Connection And Log In
Suite Teardown          Close All Connections

*** Variables ***
${SEL_TIME_INVALID}     01/01/1969 00:00:00
${SEL_TIME_VALID}       02/29/2016 09:10:00
${SET_EPOCH_TIME}       01/01/1970 00:00:00
${ALLOWED_TIME_DIFF}    2

*** Test Cases ***

Get SEL Time
    [Documentation]   ***GOOD PATH***
    ...               This test case tries to get sel time using IPMI and
    ...               then tries to cross check with BMC date time.
    ...               Expectation is that BMC time and ipmi sel time should match.

    ${resp}=    Run IPMI Standard Command    sel time get
    Should Not Be True    '${resp}'=='error'    Get time using IPMI FAILED
    ${ipmidate}=    Convert Date    ${resp}    date_format=%m/%d/%Y %H:%M:%S    exclude_millis=yes
    ${bmcdate}=    Get BMC Time And Date
    ${diff}=    Subtract Date From Date    ${bmcdate}    ${ipmidate}
    Should Be True      ${diff} < ${ALLOWED_TIME_DIFF}    Open BMC time does not match with IPMI SEL time

Set Valid SEL Time
    [Documentation]   ***GOOD PATH***
    ...               This test case tries to set sel time using IPMI and
    ...               then tries to cross check if it is correctly set in BMC.
    ...               Expectation is that BMC time should match with new time.

    ${resp}=    Run IPMI Standard Command    sel time set "${SEL_TIME_VALID}"
    Should Not Be True    '${resp}'=='error'    Set valid time using IPMI FAILED
    ${setdate}=    Convert Date    ${SEL_TIME_VALID}    date_format=%m/%d/%Y %H:%M:%S    exclude_millis=yes
    ${bmcdate}=    Get BMC Time And Date
    ${diff}=    Subtract Date From Date    ${bmcdate}    ${setdate}
    Should Be True      ${diff} < ${ALLOWED_TIME_DIFF}     Open BMC time does not match with IPMI SEL time

Set SEL Time after setting epoch time
    [Documentation]   ***GOOD PATH***
    ...               This test case tries to set sel time to epoch time and
    ...               then tries to set to to valid time.
    ...               Expectation is that new time can be set on a system with epoch time.

    ${resp}=    Run IPMI Standard Command    sel time set "${SET_EPOCH_TIME}"
    Should Not Be True    '${resp}'=='error'    Set time to epoch date using IPMI FAILED
    ${setdate_epoch}=    Convert Date    ${SET_EPOCH_TIME}    date_format=%m/%d/%Y %H:%M:%S    exclude_millis=yes
    ${bmcdate}=    Get BMC Time And Date
    ${diff}=    Subtract Date From Date    ${bmcdate}    ${setdate_epoch}
    Should Be True      ${diff} < ${ALLOWED_TIME_DIFF}    Open BMC time does not match with epoch time

    ${resp}=    Run IPMI Standard Command    sel time set "${SEL_TIME_VALID}"
    Should Not Be True    '${resp}'=='error'    Set valid time using IPMI FAILED
    ${setdate}=    Convert Date    ${SEL_TIME_VALID}    date_format=%m/%d/%Y %H:%M:%S    exclude_millis=yes
    ${bmcdate}=    Get BMC Time And Date
    ${diff}=    Subtract Date From Date    ${bmcdate}    ${setdate}
    Should Be True      ${diff} < ${ALLOWED_TIME_DIFF}     Open BMC time does not match with IPMI SEL time

Set Invalid SEL Time
    [Documentation]   ***BAD PATH***
    ...               This test case tries to run ipmi sel time set command with invalid time
    ...               Expectation is that it should return error.

    ${resp}=    Run IPMI Standard Command    sel time set "${SEL_TIME_INVALID}"
    Should Be True    '${resp}'=='error'

Set SEL Time with no time
    [Documentation]   ***BAD PATH*** 
    ...               This test case tries to run ipmi sel time set command with no time.
    ...               Expectation is that it should return error.

    ${resp}=    Run IPMI Standard Command    sel time set
    Should Be True    '${resp}'=='error'

*** Keywords ***

Get BMC Time And Date
    ${rc}=    Execute Command     date "+%m/%d/%Y %H:%M:%S"
    ${resp}=    Convert Date    ${rc}     date_format=%m/%d/%Y %H:%M:%S      exclude_millis=yes
    Should Not Be Empty    ${resp}
    [return]    ${resp}
