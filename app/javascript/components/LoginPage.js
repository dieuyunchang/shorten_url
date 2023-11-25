import React, { useState, useEffect, useRef } from "react";
import styled from "styled-components"

const LoginPageContainer = styled.div `
  max-width: 800px;
  margin: 50px auto;
  padding: 30px;

  .input {
    margin-bottom: 10px;
  }
`

const FormInput = styled.input `
  width: 100%;
  height: 31px;
`
const SubmitButton = styled.button `
  width: 100%;
  height: 31px;
  border-radius: 5px;
  padding: 3px 8px;
  background: #1f6df3e0;
  color: #fff;
  box-shadow: none;
  outline: none;
  border: 1px solid #1f6df3e0;
`
function LoginPage({loginUrl, onLogin, defaultErrorMessage, visible}) {
  const emailInput = useRef();
  const passwordInput = useRef();
  const [errorMessage, setErrorMessage] = useState(defaultErrorMessage);

  if (!visible) {
    return;
  }

  function handleSubmit() {
    if (!emailInput.current.value) {
      setErrorMessage("Email can't be blank!")
      return;
    }
    if (!passwordInput.current.value) {
      setErrorMessage("Password can't be blank!")
      return;
    }

    const requestBody = { user: { email: emailInput.current.value, password: passwordInput.current.value }}

    const requestData = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(requestBody)
    };
    fetch(loginUrl, requestData)
      .then(response => {
        if (response.ok) {
          let authorization = response.headers.get('Authorization').split(" ")
          localStorage.user_token = authorization[1];
          return response.json();
        }
        return Promise.reject(response)
      })
      .then(data => {
        setErrorMessage("")
        let user = data.status.data.user;
        localStorage.user_email = user.email
        let token = localStorage.getItem("user_token")
        onLogin(token)
      })
      .catch(error => {
        error.json().then((message) => {
          if (message.error) {
            setErrorMessage(message.error)
          }
        })
      });
  }

  return (
    <LoginPageContainer>
      <h2>Hello there! Welcome to the shorten url service!</h2>
      <h3>Login</h3>
      <div className="login">
        <div className="input email">
          <label>Email</label>
          <FormInput name="email" ref={emailInput} />
        </div>
        <div className="input password">
          <label>Password</label>
          <FormInput name="password" type="password" ref={passwordInput} />
        </div>
        <div className="actions">
          <SubmitButton onClick={handleSubmit}>Login</SubmitButton>
        </div>
        { errorMessage && 
          <Error>Opps! Something went wrong: '{errorMessage}'. Please try again!</Error> 
        }
      </div>
    </LoginPageContainer>
  )
}
export default LoginPage;
