*** Settings ***
Resource                ../lib/resource.txt

Library                 OperatingSystem

*** Keywords ***

Wait For Host To Ping
    [Arguments]     ${host}
    Wait Until Keyword Succeeds     ${OPENBMC_REBOOT_TIMEOUT}min    5 sec   Ping Host   ${host}

Ping Host
    [Arguments]     ${host}
    ${RC}   ${output} =     Run and return RC and Output    ping -c 4 ${host}
    Log     RC: ${RC}\nOutput:\n${output}
    Should be equal     ${RC}   ${0}