import React, { useState, useRef } from "react";
import styled from "styled-components"
import {CopyToClipboard} from 'react-copy-to-clipboard';
import LoginPage from "./LoginPage";

const LinkPageContainer = styled.div `
  max-width: 1200px;
  margin: 50px auto;
`
const Error = styled.div `
  padding: 10px;
  color: red;
`

const OriginalUrlInput = styled.input `
  width: 70%;
  height: 31px;
  margin-right: 5px;
`
const CreateButton = styled.button `
  height: 31px;
  border-radius: 5px;
  padding: 3px 8px;
  background: #1f6df3e0;
  color: #fff;
  box-shadow: none;
  outline: none;
  border: 1px solid #1f6df3e0;
`

const ShortenedUrl = styled.div `
  padding: 10px;
  border: 1px solid #1f6df3e0;
  margin-top: 10px;
  border-radius: 5px;

  h5 {
    margin-top: 0;
  }

  > .shortened-url > span {
    margin-right: 10px;
  }
`

const CopyToClipboardButton = styled.button `
  height: 31px;
  border-radius: 5px;
  padding: 3px 8px;
  background: #1f6df3e0;
  color: #fff;
  box-shadow: none;
  outline: none;
  border: 1px solid #1f6df3e0;
`
const Copied = styled.span `
  margin-left: 10px;
  color: #00b900;
`

function LinkPage({createShortenedUrl, loginUrl}) {
  const [shortenedUrl, setShortenedUrl] = useState();
  const [errorMessage, setErrorMessage] = useState();
  const [userToken, setUserToken] = useState(localStorage.getItem("user_token"));
  const [loginFormVisible, setLoginFormVisible] = useState(userToken ? false : true);
  const [loginErrorMessage, setLoginErrorMessage] = useState();

  const [copied, setCopied] = useState(false);
  const originUrlInput = useRef();

  function handleCreateShortLink() {
    if (!originUrlInput.current.value) {
      setErrorMessage("Your original url can't be blank!")
      return;
    }

    const requestBody = { original_url: originUrlInput.current.value }
    const requestData = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        "Authorization": `Bearer ${userToken}`
      },
      body: JSON.stringify(requestBody)
    };
    fetch(createShortenedUrl, requestData)
      .then(response => {
        if (response.ok) {
          return response.json();
        }
        return Promise.reject(response)
      })
      .then(data => {
        setErrorMessage("")
        setShortenedUrl(data.data.shortened_link);
      })
      .catch(error => {
        setShortenedUrl(null)
        if (error.status == 401) {
          resetUser()
        } else {
          error.json().then((message) => {
            if (message.error) {
              setErrorMessage(message.error.join(","))
            }
          })
        }
      });
    }

    function resetUser() {
      setLoginErrorMessage("Please login before continue!")
      localStorage.user_token = null
      setUserToken(null)
      setLoginFormVisible(true)
    }

    function handleUserLogin(token) {
      setUserToken(token)
      setLoginFormVisible(false)
    }

  return(
    <>
    {
      userToken && !loginFormVisible &&
        <LinkPageContainer>
          <h1>Hello {localStorage.getItem("user_email") || "there" }! Welcome to shorten url service</h1>

          <div className="input">
            <div>
              <label> Your Original url:</label>
            </div>
            <OriginalUrlInput name="original_url" ref={originUrlInput} />

            <CreateButton onClick={handleCreateShortLink} >Get Shortened url</CreateButton>
          </div>
          <div className="shortened-url-wrapper">
            { 
              shortenedUrl && 
                <ShortenedUrl>
                  <h5>Your shorten Url: </h5>
                  <div className="shortened-url">
                    <span>{shortenedUrl}</span>
                    <CopyToClipboard text={shortenedUrl}
                      onCopy={() => setCopied(true)}>
                      <CopyToClipboardButton>Click here to copy</CopyToClipboardButton>
                    </CopyToClipboard>
                    {copied && <Copied>Copied.</Copied>}
                  </div> 
                </ShortenedUrl>
            }
            { errorMessage && 
              <Error>Opps! Something went wrong: '{errorMessage}'. Please try again!</Error> 
            }
          </div>
        </LinkPageContainer>
    }
    <LoginPage
      visible={loginFormVisible}
      loginUrl={loginUrl}
      onLogin={handleUserLogin}
      defaultErrorMessage={loginErrorMessage}
    />
    </>
  )
}


export default LinkPage;
