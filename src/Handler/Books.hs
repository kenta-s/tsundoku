{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
module Handler.Books where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)

data BookForm = BookForm
    { title :: Text
    , url :: Text
    }

getBooksR :: Handler Html
getBooksR = error "Not yet implemented: getBooksR"

postBooksR :: Handler ()
postBooksR = do
    ((result, formWidget), formEnctype) <- runFormPost bookForm
    case result of
        FormSuccess book -> do
            liftIO $ Prelude.print $ title book
            runDB $ insert $ Book (title book) (url book)
            redirect HomeR
        _ -> redirect HomeR

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
