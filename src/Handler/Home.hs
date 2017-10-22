{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
import Text.Julius (RawJS (..))

-- Define our data that will be used for creating the form.
data FileForm = FileForm
    { fileInfo :: FileInfo
    , fileDescription :: Text
    }

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = do
    books <- runDB $ selectList [] [Desc BookId]
    ((result, formWidget), formEnctype) <- runFormPost bookForm
    let submission = Nothing :: Maybe FileForm
        handlerName = "getHomeR" :: Text
    defaultLayout $ do
        let (commentFormId, commentTextareaId, commentListId) = commentIds
        aDomId <- newIdent
        setTitle "Tsundoku"
        $(widgetFile "homepage")

postHomeR :: Handler Html
postHomeR = do
    books <- runDB $ selectList [] [Desc BookId]
    ((result, formWidget), formEnctype) <- runFormPost bookForm
    let handlerName = "postHomeR" :: Text
        submission = case result of
            FormSuccess res -> Just res
            _ -> Nothing

    defaultLayout $ do
        let (commentFormId, commentTextareaId, commentListId) = commentIds
        aDomId <- newIdent
        setTitle "Tsundoku"
        $(widgetFile "homepage")

data BookForm = BookForm
    { title :: Text
    , url :: Text
    }

bookForm :: Form BookForm
bookForm = renderBootstrap3 BootstrapBasicForm $ BookForm
    <$> areq textField (textSettings "title") Nothing
    <*> areq textField (textSettings "url") Nothing
    where textSettings name = FieldSettings
            { fsLabel = "label"
            , fsTooltip = Nothing
            , fsId = Nothing
            , fsName = Just name
            , fsAttrs =
                [ ("class", "form-control")
                , ("placeholder", name)
                ]
            }

sampleForm :: Form FileForm
sampleForm = renderBootstrap3 BootstrapBasicForm $ FileForm
    <$> fileAFormReq "Choose a file"
    <*> areq textField textSettings Nothing
    -- Add attributes like the placeholder and CSS classes.
    where textSettings = FieldSettings
            { fsLabel = "What's on the file?"
            , fsTooltip = Nothing
            , fsId = Nothing
            , fsName = Nothing
            , fsAttrs =
                [ ("class", "form-control")
                , ("placeholder", "File description")
                ]
            }

commentIds :: (Text, Text, Text)
commentIds = ("js-commentForm", "js-createCommentTextarea", "js-commentList")
