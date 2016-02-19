*** Settings ***

Documentation       This suite is for testing Open BMC user account management.

Resource            ../lib/rest_client.robot
Resource            ../lib/utils.robot

Library             OperatingSystem
Library             SSHLibrary
Library             String

*** Variables ***
${RANDOM_STRING_LENGTH}    ${8}

*** Test Cases ***

Create & delete user group
    [Documentation]     This testcase is for testing user group creation
    ...                 and deletion in open bmc.\n

    ${groupname} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${resp} =    Create UserGroup    ${groupname}
    Should Be Equal    ${resp}    ${0}
    ${usergroup_list} =    Get GroupListUsr
    Should Contain     ${usergroup_list}    ${groupname}
    ${resp} =    Delete Group    ${groupname}
    Should Be Equal    ${resp}    ${0}

Create & delete system group
    [Documentation]     This testcase is for testing system group creation
    ...                 and deletion in open bmc.\n

    ${groupname} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${resp} =    Create SysGroup    ${groupname}
    Should Be Equal    ${resp}    ${0}
    ${systemgroup_list} =    Get GroupListSys
    Should Contain     ${systemgroup_list}    ${groupname}
    ${resp} =    Delete Group    ${groupname}
    Should Be Equal    ${resp}    ${0}

Create and delete user without groupname
    [Documentation]     This testcase is for testing user creation with
    ...                 without groupname in open bmc.\n

    ${username} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${password} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${comment} =    Generate Random String    ${RANDOM_STRING_LENGTH}

    ${resp} =    Create User    ${comment}    ${username}    ${EMPTY}    ${password}
    Should Be Equal    ${resp}    ${0}
    ${user_list} =    Get UserList
    Should Contain     ${user_list}    ${username}

    Login BMC    ${username}    ${password}
    ${rc}=    Execute Command    echo Login    return_stdout=False    return_rc=True
    Should Be Equal    ${rc}    ${0}

    ${resp} =    Delete User    ${username}
    Should Be Equal    ${resp}    ${0}

Create and delete user with user group name
    [Documentation]     This testcase is for testing user creation with
    ...                 user name, password, comment and group name(user group)
    ...                 in open bmc.\n

    ${username} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${password} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${comment} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${groupname} =    Generate Random String    ${RANDOM_STRING_LENGTH}

    ${resp} =    Create UserGroup    ${groupname}
    Should Be Equal    ${resp}    ${0}
    ${resp} =    Create User    ${comment}    ${username}    ${groupname}    ${password}
    Should Be Equal    ${resp}    ${0}
    ${user_list} =    Get UserList
    Should Contain     ${user_list}    ${username}

    Login BMC    ${username}    ${password}
    ${rc}=    Execute Command    echo Login    return_stdout=False    return_rc=True
    Should Be Equal    ${rc}    ${0}

    ${resp} =    Delete User    ${username}
    Should Be Equal    ${resp}    ${0}
    ${resp} =    Delete Group    ${groupname}
    Should Be Equal    ${resp}    ${0}

Create user with user with system group name
    [Documentation]     This testcase is for testing user creation with
    ...                 user name, password, comment and group name(system group)
    ...                 in open bmc.\n

    ${username} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${password} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${comment} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${groupname} =    Generate Random String    ${RANDOM_STRING_LENGTH}

    ${resp} =    Create SysGroup    ${groupname}
    Should Be Equal    ${resp}    ${0}
    ${resp} =    Create User    ${comment}    ${username}    ${groupname}    ${password}
    Should Be Equal    ${resp}    ${0}
    ${user_list} =    Get UserList
    Should Contain     ${user_list}    ${username}

    Login BMC    ${username}    ${password}
    ${rc}=    Execute Command    echo Login    return_stdout=False    return_rc=True
    Should Be Equal    ${rc}    ${0}

    ${resp} =    Delete User    ${username}
    Should Be Equal    ${resp}    ${0}
    ${resp} =    Delete Group    ${groupname}
    Should Be Equal    ${resp}    ${0}

Create existing user
    [Documentation]     This testcase is for checking that user creation is not allowed
    ...                 for existing user in open bmc.\n

    ${username} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${password} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${comment} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${groupname} =    Generate Random String    ${RANDOM_STRING_LENGTH}

    ${resp} =    Create User    ${comment}    ${username}    ${EMPTY}    ${EMPTY}
    Should Be Equal    ${resp}    ${0}
    ${user_list} =    Get UserList
    Should Contain     ${user_list}    ${username}
    ${resp} =    Create User    ${comment}    ${username}    ${EMPTY}    ${EMPTY}
    Should Be Equal    ${resp}    ${1}

    ${resp} =    Delete User    ${username}
    Should Be Equal    ${resp}    ${0}

Create user with no name
    [Documentation]     This testcase is for checking that user creation is not allowed
    ...                 for empty username.
    ...                 in open bmc.\n

    ${username} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${password} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${comment} =    Generate Random String    ${RANDOM_STRING_LENGTH}
    ${groupname} =    Generate Random String    ${RANDOM_STRING_LENGTH}

    ${resp} =    Create User    ${comment}    ${EMPTY}    ${groupname}    ${password}
    Should Be Equal    ${resp}    ${1}

Create existing user group
    [Documentation]     This testcase is for checking that user group creation is not allowed
    ...                 for existing user group in open bmc.\n

    ${groupname} =    Generate Random String    ${RANDOM_STRING_LENGTH}

    ${resp} =    Create UserGroup    ${groupname}
    Should Be Equal    ${resp}    ${0}
    ${usergroup_list} =    Get GroupListUsr
    Should Contain     ${usergroup_list}    ${groupname}
    ${resp} =    Create UserGroup    ${groupname}
    Should Be Equal    ${resp}    ${1}

    ${resp} =    Delete Group    ${groupname}
    Should Be Equal    ${resp}    ${0}

Create existing system group
    [Documentation]     This testcase is for checking that system group creation is not allowed
    ...                 for existing system group in open bmc.\n

    ${groupname} =    Generate Random String    ${RANDOM_STRING_LENGTH}

    ${resp} =    Create SysGroup    ${groupname}
    Should Be Equal    ${resp}    ${0}
    ${systemgroup_list} =    Get GroupListSys
    Should Contain     ${systemgroup_list}    ${groupname}
    ${resp} =    Create SysGroup    ${groupname}
    Should Be Equal    ${resp}    ${1}

    ${resp} =    Delete Group    ${groupname}
    Should Be Equal    ${resp}    ${0}

Create user group with no name
    [Documentation]     This testcase is for checking that user group creation is not allowed
    ...                 for empty groupname.
    ...                 in open bmc.\n

    ${resp} =    Create UserGroup    ${EMPTY}
    Should Be Equal    ${resp}    ${1}
    ${usergroup_list} =    Get GroupListUsr
    Should Not Contain    ${usergroup_list}    ${EMPTY}

Create system group with no name
    [Documentation]     This testcase is for checking that system group creation is not allowed
    ...                 for empty groupname.
    ...                 in open bmc.\n

    ${resp} =    Create SysGroup    ${EMPTY}
    Should Be Equal    ${resp}    ${1}
    ${systemgroup_list} =    Get GroupListSys
    Should Not Contain    ${systemgroup_list}    ${EMPTY}

*** Keywords ***

Get UserList
    ${data} =   create dictionary   data=@{EMPTY}
    ${resp} =   OpenBMC Post Request   /org/openbmc/UserManager/Users/action/UserList   data=${data}
    should be equal as strings    ${resp.status_code}    ${HTTP_OK}
    ${jsondata} =    to json    ${resp.content}
    [return]    ${jsondata['data']}

Get GroupListUsr
    ${data} =   create dictionary   data=@{EMPTY}
    ${resp} =   OpenBMC Post Request   /org/openbmc/UserManager/Groups/action/GroupListUsr   data=${data}
    should be equal as strings    ${resp.status_code}    ${HTTP_OK}
    ${jsondata} =    to json    ${resp.content}
    [return]    ${jsondata['data']}

Get GroupListSys
    ${data} =   create dictionary   data=@{EMPTY}
    ${resp} =   OpenBMC Post Request   /org/openbmc/UserManager/Groups/action/GroupListSys   data=${data}
    should be equal as strings    ${resp.status_code}    ${HTTP_OK}
    ${jsondata} =    to json    ${resp.content}
    [return]    ${jsondata['data']}

Create User
    [Arguments]    ${comment}    ${username}    ${groupname}    ${password}
    @{user_list} =   Create List     ${comment}    ${username}    ${groupname}    ${password}
    ${data} =   create dictionary   data=@{user_list}
    ${resp} =   OpenBMC Post Request    /org/openbmc/UserManager/Users/action/UserAdd      data=${data}
    should be equal as strings    ${resp.status_code}    ${HTTP_OK}
    ${jsondata} =    to json    ${resp.content}
    [return]    ${jsondata['data']}
   
Create SysGroup
    [Arguments]    ${args}
    @{group_list} =   Create List     ${args}
    ${data} =   create dictionary   data=@{group_list}
    ${resp} =   OpenBMC Post Request    /org/openbmc/UserManager/Groups/action/GroupAddSys      data=${data}
    should be equal as strings    ${resp.status_code}    ${HTTP_OK}
    ${jsondata} =    to json    ${resp.content}
    [return]    ${jsondata['data']}
	
Create UserGroup
    [Arguments]    ${args}
    @{group_list} =   Create List     ${args}
    ${data} =   create dictionary   data=@{group_list}
    ${resp} =   OpenBMC Post Request    /org/openbmc/UserManager/Groups/action/GroupAddUsr      data=${data}
    should be equal as strings    ${resp.status_code}    ${HTTP_OK}
    ${jsondata} =    to json    ${resp.content}
    [return]    ${jsondata['data']}

Delete Group
    [Arguments]    ${args}
    @{group_list} =   Create List     ${args}
    ${data} =   create dictionary   data=@{group_list}
    ${resp} =   OpenBMC Post Request    /org/openbmc/UserManager/Group/action/GroupDel      data=${data}
    should be equal as strings    ${resp.status_code}    ${HTTP_OK}
    ${jsondata} =    to json    ${resp.content}
    [return]    ${jsondata['data']}

Delete User
    [Arguments]    ${args}
    @{user_list} =   Create List     ${args}
    ${data} =   create dictionary   data=@{user_list}
    ${resp} =   OpenBMC Post Request    /org/openbmc/UserManager/User/action/Userdel      data=${data}
    should be equal as strings    ${resp.status_code}    ${HTTP_OK}
    ${jsondata} =    to json    ${resp.content}
    [return]    ${jsondata['data']}

Login BMC
    [Arguments]    ${username}    ${password}
    Open connection     ${OPENBMC_HOST}
    ${resp} =   Login   ${username}    ${password}
    [return]    ${resp}
