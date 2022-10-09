/* Q3 */

SELECT Name as 'Country Name'
FROM country c JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE cl.Language = 'English'
ORDER BY Name ASC;

/* Q4 */

SELECT Name as 'Country Name'
FROM country c JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE cl.Language = 'English' and Percentage = '100.0'
ORDER BY Name ASC;

/* Q5 */

SELECT Language as 'Lang of UK'
FROM country c JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE Name ='United Kingdom';

/* Q6 */

SELECT country.Name AS 'CountryName', city.Name AS 'CapitalName', city.Population AS 'CapitalPopulation'
FROM country JOIN city ON country.capital = city.id
WHERE city.population >= 4000000;

/* Q7 */

SELECT country.Name as 'CountryName', city.Name AS 'CityName'
FROM country JOIN city ON country.Code = city.CountryCode
WHERE city.ID != country.Capital
ORDER BY country.Name ASC, city.Name ASC;

/* Q8 */

SELECT city.CountryCode, country.Name AS 'CountryName' , country.Population as 'CountryPopulation', count(city.ID) AS 'CityCount', SUM(city.Population) AS 'TotCityPopulation' 
FROM country JOIN city ON country.Code = city.CountryCode
WHERE country.Continent = 'Africa'
GROUP BY city.CountryCode
ORDER BY country.Name;

/* Q9 */

SELECT a.CountryName AS 'CountryName', a.Name AS 'Largest City', a.Population AS 'LargestCityPopulation', b.Name AS 'Smallest City', b.Population AS 'SmallestCityPopulation',  c.LangConcat FROM
(SELECT country.Name AS 'CountryName' , city.CountryCode, city.Name, city.Population FROM 
city JOIN country ON city.ID = country.Capital WHERE city.Population IN (SELECT MAX(city.Population) FROM city group by CountryCode )) a 
JOIN (SELECT  CountryCode, Name, Population FROM 
city WHERE Population IN (SELECT MIN(Population) FROM city group by CountryCode )) b 
ON a.CountryCode = b.CountryCode
JOIN (SELECT CountryCode, group_concat(distinct Language order by IsOfficial, Percentage DESC SEPARATOR '/') as 'LangConcat'
FROM countrylanguage group by CountryCode) c ON b.CountryCode = c.CountryCode;

/* Q10 */

SELECT 
    (SELECT AVG((SELECT
            AVG(Population) AS 'SpanishAverage'
        FROM
            countrylanguage
                JOIN
            city ON city.CountryCode = countrylanguage.CountryCode
        WHERE
            Language = 'Spanish'
                AND IsOfficial = 'T'))
                -
    (SELECT AVG((SELECT
            AVG(Population) AS 'EnglishAverage'
        FROM
            countrylanguage
                JOIN
            city ON city.CountryCode = countrylanguage.CountryCode
        WHERE
            Language = 'English'
                AND IsOfficial = 'T')))) AS 'Average'
FROM
   dual;

