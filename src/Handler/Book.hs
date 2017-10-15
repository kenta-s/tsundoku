{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
module Handler.Book where

import Import

getBookR :: BookId -> Handler Html
getBookR bookId = do
    books <- runDB $ selectList [] [Asc BookTitle]
    defaultLayout $ do
        [whamlet|
            <h1>This is simple
            <ul>
                $forall Entity bookid book <- books
                    <li>
                        #{bookTitle book}
        |]

postBookR :: BookId -> Handler Html
postBookR bookId = error "Not yet implemented: postBookR"

deleteBookR :: BookId -> Handler Html
deleteBookR bookId = error "Not yet implemented: deleteBookR"
