require 'topcoder/problem'
require 'topcoder/download' 

require 'uri' 
require 'pathname' 
require 'hpricot'
require 'pathname' 

module TopCoder
    class Parser 
        def initialize downloader
            @downloader = downloader
            @images = []            
        end

        ## @section Utils

        def indexes str, substr
            from = str.index substr
            return nil if from.nil?
            to = from + substr.size
            return from - 1, to
        end
        def filter html
            html.gsub! /<b>(\w*)<\/b>/ do |match|
                "*#{$1}*"
            end 
            html.gsub! /<sup>(\w*)<\/sup>/ do |match|
                "^(#{$1})"
            end 
            html.gsub! '&#160;', ''
            html.gsub! '&nbsp;', ' '
            text = Hpricot(html).to_plain_text
            text.gsub! /\[img:(http:\/\/.*)\]/ do |match|
                url = $1
                image = Image.new
                image.name = Pathname.new(url).basename
                image.content = @downloader.download url
                @images << image
                "![image](images/#{image.name})"
            end 
            return text
        end
        def h3 tag
            return "<h3>#{tag}</h3>"
        end

        ## @section Parse problem parts

        def parse_name html
            html.sub! 'Problem Statement for', ''
            return filter html
        end
        def parse_source elem
            url = 'http://www.topcoder.com' + elem.attributes['href']
            source = filter elem.html
            return url, source
        end
        def parse_statement html
            return filter html
        end
        def parse_definitions html
            defs = { }
            Hpricot(html).search '/tr/td.statText/table/tr' do |tr|
                tds = tr.search '/td.statText'
                if tds.size == 2 then
                    key = tds[0].to_plain_text[0 .. -2]
                    value = tds[1].to_plain_text
                    defs[key] = value
                end 
            end 
            return defs
        end
        def parse_notes html
            notes = []
            Hpricot(html).search '/tr' do |tr|
                tds = tr.search '/td.statText'
                if tds.size == 2 then
                    notes << filter(tds[1].html)
                end 
            end 
            return notes
        end
        def parse_constraints html
            return parse_notes html
        end

        ## @section Parse cases

        def filter_inout text
            text.gsub! '{', '['
            text.gsub! '}', ']'
            return text.strip
        end
        def parse_input html
            text = nil
            Hpricot(html).search '/table/tr/td.statText' do |td|
                input = td.to_plain_text.strip
                if text.nil? then
                    text = input
                else
                    text << ",\n" << input
                end 
            end
            return filter_inout text
        end
        def parse_output html
            text = Hpricot(html).to_plain_text
            text.sub! 'Returns: ', ''
            return filter_inout text
        end
        def parse_reason html
            return filter html
        end
        def parse_examples html
            examples = []
            tds = Hpricot(html).search('/tr/td.statText/table/tr/td.statText')
            i = 0
            while i < tds.size do
                example = Case.new
                example.input = parse_input tds[i].html
                example.output = parse_output tds[i += 1].html
                example.reason = parse_reason tds[i += 1].html
                examples << example 
                i += 1
            end
            return examples
        end
        def parse_systests html
            systests = []
            _, y = indexes html, '<!-- System Testing -->'
            z, _ = indexes html, '<!-- End System Testing -->'
            Hpricot(html[y .. z]).search '/table/tr[@valign=top]' do |tr|
                tds = tr.search '/td.statText'    
                if tds.size == 3 then
                    test = Case.new
                    test.input = filter_inout tds[0].to_plain_text
                    test.output = filter_inout tds[1].to_plain_text
                    systests << test 
                end 
            end 
            return systests
        end

        ## @section Main method

        def parse html
            @images = []            
            prob = Problem.new 
            doc = Hpricot(html)

            prob.name = parse_name doc.search('tr/td.statTextBig').html
            prob.url, prob.source = 
                parse_source doc.at 'a[@href^=/tc?module=ProblemDetail]'

            prob.notes = nil
            prob.constraints = nil
            prob.examples = nil 

            html = doc.search('td.problemText/table').html

            _, x = indexes html, h3('Problem Statement')
            y, z = indexes html, h3('Definition')
            prob.statement = parse_statement html[x .. y]

            x, y = indexes html, h3('Notes')
            if x.nil? then
                prob.notes = []
                x, y = indexes html, h3('Constraints')
                if x.nil? then
                    prob.constraints = []
                    x, y = indexes html, h3('Examples')
                    if x.nil? then
                        prob.examples = []
                        x = -2
                    end 
                end 
            end 
            prob.definitions = parse_definitions html[z .. x]

            if prob.notes.nil? then
                z, x = indexes html, h3('Constraints')
                if z.nil? then
                    prob.constraints = []
                    z, x = indexes html, h3('Examples') 
                    if z.nil? then
                        prob.examples = []
                        z = - 2
                    end 
                end 
                prob.notes = parse_notes html[y .. z]
                x, y = z, x
            end 

            if prob.constraints.nil? then
                z, x = indexes html, h3('Examples')
                if z.nil? then
                    prob.examples = []
                    z = -2
                end 
                prob.constraints = parse_constraints html[y .. z]
            end 

            if prob.examples.nil? then
                prob.examples = parse_examples html[x .. -2]
            end 

            html = @downloader.download prob.url
            link = Hpricot(html).at 'a[@href^=/stat?c=problem_solution]'
            if not link.nil? then
                html = @downloader.download link.attributes['href']
                prob.systests = parse_systests html 
            end 

            prob.images = @images

            return prob
        end    
    end
end