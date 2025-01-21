*** Settings ***
Library    SeleniumLibrary    run_on_failure=None
Library    BuiltIn
Library    OperatingSystem
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Suite Teardown Keyword

*** Variables ***
${IMPLICIT_WAIT}    10s
${EXPLICIT_WAIT}    10s
${BROWSER}    chrome
${URL}    https://the-internet.herokuapp.com/login
${REPORTDIR}    pic


*** Keywords ***
# set Implicit
Suite Setup Keyword
    Log    Suite setup initiated with report folder ${REPORTDIR}
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}

Suite Teardown Keyword
    Log    Suite teardown completed.

# Test-Level Keywords
Test Setup Keyword
    Log    Test setup initiated.

Test Teardown Keyword
    Run Keyword If    '${TEST_STATUS}' == 'FAIL'    Capture Page Screenshot    ${REPORTDIR}/fail/FAILURE.png

# Capture screenshot
Capture Screenshot
    [Arguments]    ${screenshot_file}
    ${timestamp}    Evaluate    str(int(time.time()))    time
    Capture Page Screenshot    ${REPORTDIR}/pass/${timestamp}_${screenshot_file}

# Verify title
Verify Title
    [Arguments]    ${expected_title}
    ${tittle}=    Get Title
    Log    ${tittle}
    Title Should Be    ${expected_title}

# Verify text equal
Verify Text Equal
    [Arguments]    ${element}    ${expected_title}
    ${text}=    Get Text    ${element}
    Should Contain    ${text}    ${expected_title} 

Wait Explicit And Click
    [Arguments]    ${element}
    Wait Until Element Is Visible    ${element}    ${EXPLICIT_WAIT}
    Wait Until Element Is Enabled    ${element}    ${EXPLICIT_WAIT}
    Click Element    ${element}

***Test Cases ***
# เข้าสู่ระบบสำเร็จ
Login success    
    Navigate To LoginPage
    Input Detail Login    tomsmith    SuperSecretPassword!
    Check Login Pass and Logout

# เข้าสู่ระบบไม่สำเร็จ - password
Login failed - Password incorrect   
    Navigate To LoginPage
    Input Detail Login    tomsmith    Password!
    Check Login Fail Password

# เข้าสู่ระบบไม่สำเร็จ - username
Login failed - Username not found  
    Navigate To LoginPage
    Input Detail Login    tomholland    Password!
    Check Login Fail Username

*** Keywords ***
# เข้าหน้า Login
Navigate To LoginPage
    # Create ChromeOptions object
    ${options}=    Evaluate    sys.modules['selenium.webdriver.chrome.options'].Options()    sys, selenium.webdriver.chrome.options
    # Add desired arguments to options
    Call Method    ${options}    add_argument    --disable-web-security
    Call Method    ${options}    add_argument    --disable-extensions
    Open Browser    ${URL}    chrome    options=${options} 
    Maximize Browser Window
    Sleep    1s   
    # เช็คหน้า Login
    Verify Title    The Internet
    Verify Text Equal    css=div[class='example'] h2    Login Page
    Capture Screenshot    loginpage.png

# ใส่รายละเอียด Login
Input Detail Login
    [Arguments]    ${txt_username}    ${txt_password}
    # ใส่ username/password
    Input Text    id=username    ${txt_username}
    Input Text    id=password    ${txt_password}
    Capture Screenshot    detail-login.png
    # กด Login
    Wait Explicit And Click    css=form[id='login'] button
    Sleep    1s

# เช็ค Login สำเร็จ
Check Login Pass and Logout
    # เช็คหน้า
    Verify Text Equal    id=flash    You logged into a secure area!
    Verify Text Equal    css=div.example h2     Secure Area
    Capture Screenshot    login-pass.png
    # กด Logout
    Wait Explicit And Click    css=div[id='content'] a
    Sleep    1s
    # เช็ค Logout
    Verify Text Equal    id=flash    You logged out of the secure area!
    Capture Screenshot    logout.png

# เช็ค Login ไม่สำเร็จ
Check Login Fail Password
    # เช็คหน้า
    Verify Text Equal    id=flash    Your password is invalid!
    Capture Screenshot    login-fail-password.png

# เช็ค Login ไม่สำเร็จ
Check Login Fail Username
    # เช็คหน้า
    Verify Text Equal    id=flash    Your username is invalid!
    Capture Screenshot    login-fail-username.png