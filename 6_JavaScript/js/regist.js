window.onload = function () {
    const ssn1 = document.getElementById("ssn1")
    ssn1.addEventListener("keyup", () => {
        if (ssn1.value.length >= 6) {
            document.getElementById("ssn2").focus()
        }
    })

    const ssn = document.querySelectorAll(".ssn")
    ssn.forEach((s) => {
        // console.log(s)
        s.addEventListener("input", () => {
            document.getElementById("ssncheck").value = "n"
        })
    })
}



function sendit() {
    const userid = document.getElementById("userid")
    const userpw = document.getElementById("userpw")
    const userpw_re = document.getElementById("userpw_re")
    const name = document.getElementById("name")
    const hp = document.getElementById("hp")
    const email = document.getElementById("email")
    const ssncheck = document.getElementById("ssncheck")

    const expIdText = /^[A-Za-z0-9]{4,20}$/
    /*
        (?=.*): 어디엔가 원하는 패턴이 하나라도 있어야 함
        (?=.*[A-Za-z]): 영문자가 최소 1개 이상 있어야 함
        (?=.*\d): 숫자가 최소 1개 이상 있어야 함
        (?=.*[!@#$%^&*()]): 제시된 특수 문자중 최소 1개 이상 있어야 함
    */
    const expPwText = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()])[A-Za-z\d!@#$%^&*()]{8,20}$/
    const expNameText = /^[가-힣]+$/
    const expHpText = /^010-\d{3,4}-\d{4}$/
    const expEmailText = /^[A-Za-z0-9\-\.]+@[A-Za-z0-9\-]+\.[A-Za-z]+$/

    if (userid.value === "") {
        alert("아이디를 입력하세요")
        userid.focus()
        return false
    }

    if (!expIdText.test(userid.value)) {
        alert("아이디는 4자 이상 20자 이하의 영문자 또는 숫자로 입력하세요")
        userid.focus()
        return false
    }

    if (!expPwText.test(userpw.value)) {
        alert("비밀번호는 8자 이상 20자 이하의 영문자, 숫자, 특수문자를 한 자 이상 꼭 포함해야 합니다.")
        userpw.focus()
        return false
    }

    if (userpw.value != userpw_re.value) {
        alert("비밀번호와 비밀번호 확인이 일치하지 않습니다")
        userpw_re.focus()
        return false
    }

    if (!expNameText.test(name.value)) {
        alert("이름은 한글로 입력해야합니다")
        name.focus()
        return false
    }

    if (!expHpText.test(hp.value)) {
        alert("휴대폰번호 형식이 일치하지 않습니다\n하이픈을 꼭 입력하세요")
        hp.focus()
        return false
    }

    if (!expEmailText.test(email.value)) {
        alert("이메일 형식이 일치하지 않습니다")
        email.focus()
        return false
    }

    if (ssncheck.value == "n") {
        alert("주민등록번호 검증버튼을 눌러주세요")
        return false
    }
}

/*
function checkSsn() {
    const ssn1 = document.getElementById("ssn1")
    const ssn2 = document.getElementById("ssn2")

    let ssn = ssn1.value + ssn2.value.substring(0, 6)
    const cond = ssn2.value[6]

    console.log(cond)
    ssn = ssn.split('')
    console.log(ssn, typeof ssn)
    let check = 0

    let mul = 2
    for (let i = 0; i < ssn.length; i++) {
        check += Number(ssn[i]) * mul

        if (mul < 9) {
            mul++
        } else {
            mul = 2
        }
    }

    check = check % 11
    check = 11 - check
    if (check >= 10) {
        check = check % 10
    }
    if (check != cond) {
        alert("주민번호가 유효하지 않습니다")
        ssn1.focus()
        return false
    }
    alert("딩동댕")
    console.log(check)
}
*/

function checkSsn() {
    let ssncheck = document.getElementById("ssncheck")
    const ssn1 = document.getElementById("ssn1")
    const ssn2 = document.getElementById("ssn2")
    const ssn = ssn1.value + ssn2.value

    const weights = [2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5]
    let result = 0;

    for (let i = 0; i < weights.length; i++) {
        result += parseInt(ssn[i] * weights[i])
    }
    result = (11 - (result % 11)) % 10

    if (result == parseInt(ssn[12])) {
        alert("유효한 주민등록번호입니다")
        ssncheck.value = "y"
    } else {
        alert("유효하지 않은 주민등록번호입니다")
    }
}