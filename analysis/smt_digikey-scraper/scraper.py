from array import array
from bs4 import BeautifulSoup
from requests_html import HTMLSession
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import csv
import time
import json

def start():
    urls = get_urls()
    with open('output.txt', 'w') as filehandle:
        json.dump(urls, filehandle)
    pages_data = get_pages_data(urls)
    write_csv(pages_data)


def get_urls() -> array:
    urls = []

    url = "https://www.digikey.ca/en/products/filter/embedded-microcontrollers/685?s=N4IgrCBcoA5QjADgJwGYA0IZ0gJjAL4FA"
    urls.append(url)

    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
    driver.maximize_window()
    driver.get(url)

    count = 1894
    retries = 0
    while retries <= 2 and count <= 2990:
        try:
            # wait for xyz seconds until page button appears
            WebDriverWait(driver, 60).until(EC.presence_of_element_located(
                (By.XPATH, f'//button[@data-testid="btn-page-{count}"]')))

            # set the preclick url to the current url
            preclick_url = driver.current_url

            # click the next page button
            button = driver.find_element(
                by=By.XPATH, value=f'//button[@data-testid="btn-page-{count}"]')
            button.click()

            # wait for a new page to load
            while driver.current_url == preclick_url:
                time.sleep(1)

            urls.append(driver.current_url)
            print(count, " : ", driver.current_url)
            count += 1
        except Exception as e:
            time.sleep(60)
            if driver:
                driver.refresh()
            retries += 1
            print(e)
    return urls


def get_pages_data(urls) -> array:
    pages_data = []
    for url in urls:
        page_data = get_page_data(url)  # -> 2d array
        pages_data = add_2d_arrays(pages_data, page_data)
    return pages_data


def add_2d_arrays(super_arr, sub_arr):
    for arr in sub_arr:
        super_arr.append(arr)
    return super_arr


def get_page_data(url):
    print(url)
    s = HTMLSession()
    r = s.get(url)
    soup = BeautifulSoup(r.text, "html.parser")

    rows = soup.find_all(attrs={"data-testid": "data-table-0-row"})
    page_data = []
    for row in rows:
        name = row.find(
            "a", attrs={"data-testid": "data-table-0-product-number"}).text
        print(name)
        quantity = row.find("div", "jss287").text
        mounting_type = row.find(attrs={"data-atag": "CLS 69"}).text
        package_case = row.find(attrs={"data-atag": "CLS 16"}).text
        page_data.append([quantity, mounting_type, package_case])

    return page_data


def write_csv(data):
    # mounting type, package, supplier
    header = ['quantity', 'mounting_type', 'package_case']
    with open('cameron.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerows(data)

start()