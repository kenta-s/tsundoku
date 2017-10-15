{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
module Handler.Book where

import Import

getBookR :: BookId -> Handler Html
getBookR bookId = do
    books <- runDB $ selectList [BookId ==. bookId] [LimitTo 1]
    defaultLayout $ do
        [whamlet|
            <h1>This is simple
            $forall Entity bookid book <- books
                <p>#{bookTitle book}
                <p>#{bookUrl book}
        |]

postBookR :: BookId -> Handler Html
postBookR bookId = error "Not yet implemented: postBookR"

deleteBookR :: BookId -> Handler Html
deleteBookR bookId = error "Not yet implemented: deleteBookR"
