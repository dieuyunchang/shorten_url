import React, { useState, useEffect, useRef } from "react";
import styled from "styled-components"
import {CopyToClipboard} from 'react-copy-to-clipboard';

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

function LinkPage({createShortenedUrl}) {
  const [shortenedUrl, setShortenedUrl] = useState();
  const [errorMessage, setErrorMessage] = useState();
  const [copied, setCopied] = useState(false);
  const originUrlInput = useRef();

  function handleCreateShortLink() {
    const requestBody = { original_url: originUrlInput.current.value }
    const requestData = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
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
        setShortenedUrl(data.data.shortened_link);
      })
      .catch(error => {
        error.json().then((message) => {
          setErrorMessage(message.error.join(","))
        })

        setShortenedUrl(null);
      });
  }

  return( 
    <LinkPageContainer>
      <h1>Hello there! Welcome to shorten url service</h1>

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
  )
}


export default LinkPage;
