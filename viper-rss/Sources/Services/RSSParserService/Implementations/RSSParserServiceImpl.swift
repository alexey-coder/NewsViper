//
//  RSSParserServiceImpl.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

final class RSSParserServiceImpl: NSObject, RSSParserService {
    
    private var rssItems: [RSSEntity] = []
    private var currentElement = ""
    private var onSuccess: ((RSSEntity) -> Void)?
    private var onError: ((RSSParserError) -> Void)?
    private let semaphore = DispatchSemaphore(value: 0)

    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var pubDate: String = "" {
        didSet {
            pubDate = pubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentLink: String = "" {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPostId: String = "" {
        didSet {
            let id = currentPostId.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            currentPostId = id.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentImgLink: String = "" {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parseFeed(
        url: String,
        successCompletion: @escaping ((RSSEntity) -> Void),
        errorCompletion: @escaping ((RSSParserError) -> Void)) {
        onSuccess = successCompletion
        onError = errorCompletion
        rssItems = []
        guard let url = URL(string: url) else {
            errorCompletion(.invalidUrl)
            return
        }
        let request = URLRequest(url: url)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if error != nil {
                    errorCompletion(.dateRequestError)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            self.semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
    }
}

extension RSSParserServiceImpl: XMLParserDelegate {
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            pubDate = ""
            currentLink = ""
            currentImgLink = ""
            currentPostId = ""
            currentDescription = ""
        }
        if currentElement == "enclosure" {
            attributeDict["url"].flatMap {
                currentImgLink += $0
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "pubDate":
            pubDate += string
        case "link":
            currentLink += string
        case "description":
            currentDescription += string
        case "guid":
            currentPostId += string
        default:
            break
        }
    }
    
    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSEntity(
                title: currentTitle,
                description: currentDescription,
                pubdate: pubDate,
                link: currentLink,
                imgUrl: currentImgLink,
                postId: currentPostId)
            rssItems += [rssItem]
            onSuccess?(rssItem)
        }
    }
}
