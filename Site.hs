-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import Data.Typeable
import Data.Binary (Binary)

import OutOfTheYards.Content.Normalize (normalizeUrls)
-----------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "CNAME" $ do
        route   idRoute
        compile copyFileCompiler

    match "assets/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/style.scss" $ do
        route $ setExtension "css"
        compile $ getResourceString 
            >>= withItemBody
                (unixFilter "sass" [ "-s", "--scss", "--load-path=css"])
            >>= return . fmap compressCss

    match "posts/*/images/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "posts/**/*.md" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= normalizeUrls postCtx
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst 
                =<< loadAllSnapshots "posts/**/*.md" "content"

            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

-----------------------------------------------------------------------------
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext
