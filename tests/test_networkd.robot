*** Settings ***
Documentation		This suite will verifiy the Network Configuration Rest Interfaces
...					Details of valid interfaces can be found here...
...					https://github.com/openbmc/docs/blob/master/rest-api.md

Resource		../lib/rest_client.robot


*** Variables ***

*** Test Cases ***


Get the Mac address

    [Documentation]   ***GOOD PATH*** 
    ...               This test case is to get the mac address
    
    @{arglist}=   Create List   lo
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=   Call Method    /org/openbmc/NetworkManager/Interface/    GetHwAddress    data=${args}
    should not be empty    ${resp.content}


Get IP Address with invalid interface

    [Documentation]   ***BAD PATH*** 
    ...               This test case tries to get the ip addrees with the invalid 
    ...               interface,Expectation is it should get error.
    
    @{arglist}=   Create List   lo1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   GetAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error


Add IP address on invalid Interface

    [Documentation]   ***BAD PATH*** 
    ...               This test case tries to add the ip addrees on invalid interface
    ...               Expectation is it should get error.

    ${arglist}=    Create List    lo01    1.1.1.1   255.255.255.0   1.1.1.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   AddAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error


Add invalid IP address on the valid interface

    [Documentation]   ***BAD PATH*** 
    ...               This test case tries to add the invalid ip addrees on  the interface
    ...               Expectation is it should get error.

    ${arglist}=    Create List   lo   ab.cd.ef.gh   255.255.255.0   1.1.1.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   AddAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

Add IP address with invalid subnet mask

    [Documentation]   ***BAD PATH*** 
    ...               This test case tries to add the ip addrees on  the interface
    ...               with invalid subnet mask,Expectation is it should get error.
    
    ${arglist}=    Create List   lo   2.2.2.2   av.ih.jk.lm   1.1.1.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   AddAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error                                                 

Add empty IP address

    [Documentation]   ***BAD PATH*** 
    ...               This test case tries to add the NULL ip addrees on  the interface
    ...               Expectation is it should get error.
    
    ${arglist}=    Create List   lo   ${EMPTY}    255.255.255.0   1.1.1.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   AddAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

Add empty subnet mask

    [Documentation]   ***BAD PATH*** 
    ...               This test case tries to add the ip addrees on  the interface
    ...               with empty subnet mask,Expectation is it should get error.

    ${arglist}=    Create List   lo   2.2.2.2   ${EMPTY}   1.1.1.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   AddAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

Add empty gateway

    [Documentation]   ***BAD PATH***
    ...               This test case tries to add the ip addrees on  the interface
    ...               with empty gateway,Expectation is it should get error.

    ${arglist}=    Create List   lo   2.2.2.2   255.255.255.0   ${EMPTY}
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   AddAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

Add IP address on valid Interface

    [Documentation]   ***GOOD PATH***
    ...               This test case add the ip addresson the  interface and validates
    ...               that ip address has been added or not.
    ...               Expectation is the ip address should get added.

    ${arglist}=    Create List    lo    10.10.10.10   255.255.255.0   10.10.10.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   AddAddress4    data=${args}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    Is ip/gateway on the interface   10.10.10.10   10.10.10.1   

Delete ip address from the invalid interface

    [Documentation]   ***BAD PATH***
    ...               This test case tries to delete the ip addrees from the interface
    ...               with invalid interface,Expectation is it should get error.

   ${arglist}=    Create List    lo01    1.1.1.1   255.255.255.0   1.1.1.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   DelAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

Delete ip address with invalid subnet mask

    [Documentation]   ***BAD PATH***
    ...               This test case tries to delete the ip addrees from the interface
    ...               with invalid  gateway,Expectation is it should get error.

   ${arglist}=    Create List    lo    1.1.1.1   ab.cd.ef.gh   1.1.1.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   DelAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

Delete ip address with invalid gateway

    [Documentation]   ***BAD PATH***
    ...               This test case tries to delete the ip addrees from the interface
    ...               with invalid  gateway,Expectation is it should get error.

   ${arglist}=    Create List    lo    1.1.1.1   255.255.255.0   ij.kl.mn.op
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   DelAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

Delete empty ip address

    [Documentation]   ***BAD PATH***
    ...               This test case tries to delete NULL ip addrees from the interface.
    ...               Expectation is it should get error.

   ${arglist}=    Create List    lo   ${EMPTY}   255.255.255.0   1.1.1.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   DelAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

Delete ip address with empty subnet mask

    [Documentation]   ***BAD PATH***
    ...               This test case tries to delete the ip addrees from the interface
    ...               with empty subnet,Expectation is it should get error.

   ${arglist}=    Create List    lo    1.1.1.1   ${EMPTY}   1.1.1.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   DelAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

Delete ip address with empty gateway

    [Documentation]   ***BAD PATH***
    ...               This test case tries to delete the ip addrees from the interface
    ...               with empty gateway,Expectation is it should get error. 

   ${arglist}=    Create List    lo    1.1.1.1   ${EMPTY}   1.1.1.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   DelAddress4    data=${args}
    should not be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

Delete ip address

    [Documentation]   ***GOOD PATH***
    ...               This test case will delete the ip address from the interface 
    ...               Expectation is it should delete the ip address.

    ${arglist}=    Create List    lo    10.10.10.10   255.255.255.0   10.10.10.1
    ${args}=     Create Dictionary   data=@{arglist}
    ${resp}=    Call Method    /org/openbmc/NetworkManager/Interface/   DelAddress4    data=${args}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok


***keywords***

Is ip/gateway on the interface

    [Documentation]   This keyword is used to match the given ip with the configured one.  
    ...               returns true if match successfull else false
    ...               eg:- Outout og getAddress4
    ...               {"data": [[[2,25,0,128,"9.3.164.177"],[2,8,254,128,"127.0.0.1"]],"9.3.164.129"],
    ...                "message": "200 OK", "status": "ok"}

    [arguments]    ${i_ipaddress}   ${i_gateway}
    @{arglist}=    Create List   eth0
    ${args}=       Create Dictionary   data=@{arglist}
    ${resp}=       Call Method    /org/openbmc/NetworkManager/Interface/   GetAddress4    data=${args}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    @{interfacelist}=  Create List     ${json['data'][0]}
    ${ipaddress}=      set variable    ${json['data'][0][0][4]}
    ${gateway}=        set variable    ${json['data'][1]}
    log to console ${i_ipaddress}   ${i_gateway}
    :FOR    ${interface}    IN    @{interfacelist}
        \   log     ${interface}
        \  ${isIPfound}=  Is ip found    ${interface}   ${i_ipaddress}

    log to console   ${isIPfound}
    ${isgatewayfound} =    Set Variable If   '${gateway}'=='${i_gateway}'  true    false
    log to console   ${isgatewayfound}
    should be true   '${isIPfound}' == 'true'

Is ip found

    [Documentation]   This keyword is for to create nested for loop

    [arguments]    ${interface_info}   ${i_ipaddress}
    :FOR    ${interface}    IN    @{interface_info}
       \    Log to console     ${interface}
       \    ${ipfound}=    Set Variable if    '${interface[4]}' == '${i_ipaddress}'    true   false
       \    Run Keyword If    '${interface[4]}' == '${i_ipaddress}'    Exit For Loop

    [return]    ${ipfound}
