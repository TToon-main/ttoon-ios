import os
import sys
import json
import gspread
from oauth2client.service_account import ServiceAccountCredentials
from datetime import datetime

# JSON 파일을 읽어서 Python 객체로 반환
def read_json_file(path):
    with open(path, 'r', encoding='utf-8') as json_file:
        return json.load(json_file)

# Python 객체를 JSON 파일로 저장
def save_json_to_file(json_data, path):
    with open(path, 'w', encoding='utf-8') as json_file:
        json.dump(json_data, json_file, ensure_ascii=False, indent=4)

# JSON 데이터를 문자열로 변환하
def parse_json_to_string(json_data):
    strings = ""
    for section, values in json_data.items():
        strings += f"// {section}\n"
        for key, value in values.items():
            strings += f'"{key}" = "{value}";\n'
        strings += "\n"
    return strings

# 문자열을 파일에 저장
def save_string_to_file(strings, path):
    with open(path, 'w', encoding='utf-8') as file:
        file.write(strings)
        
# 스프레드시트의 시트를 처리하여 JSON 파일과 문자열 파일에 업데이트
def process_sheet(sheet, ko_json, en_json):
    title = sheet.title
    ko_input_json = {}
    en_input_json = {}
    
    # 시트에서 각 행을 반복하며 키-값 쌍을 추출
    for sheet_row in sheet.get_all_values()[1:]:
        key = sheet_row[0].strip()
        ko_value = sheet_row[1].strip()
        en_value = sheet_row[2].strip()
        
        # 한글과 영어 JSON에 키-값 쌍 추가
        ko_input_json.setdefault(title, {})[key] = ko_value
        en_input_json.setdefault(title, {})[key] = en_value
    
    # 기존 JSON에 업데이트된 데이터 추가
    ko_json.update(ko_input_json)
    en_json.update(en_input_json)
    
    # JSON 파일과 문자열 파일에 업데이트된 데이터 저장
    save_json_to_file(ko_json, ko_json_file_path)
    save_json_to_file(en_json, en_json_file_path)
    
    save_string_to_file(parse_json_to_string(ko_json), ko_strings_file_path)
    save_string_to_file(parse_json_to_string(en_json), en_strings_file_path)

# Google Sheets API를 사용하기 위한 인증 정보 설정
scope = [
    "https://spreadsheets.google.com/feeds",
    "https://www.googleapis.com/auth/drive",
]

# 경로 설정
PROJECT_DIR = os.environ.get("PROJECT_DIR", "")
HOME_DIR = PROJECT_DIR if PROJECT_DIR else os.getcwd()

# 스프레드 시트 인증 JSON 파일 경로 설정
JSON_KEY_PATH = os.path.join(HOME_DIR, "TTOON", "Localization", "engaged-code-418809-16024d5258d0.json")

# 각 언어에 대한 JSON 및 문자열 파일 경로 설정
ko_json_file_path = os.path.join(HOME_DIR, "TTOON", "Localization", "ko.lproj", "Localization.json")
en_json_file_path = os.path.join(HOME_DIR, "TTOON", "Localization", "en.lproj", "Localization.json")
ko_strings_file_path = os.path.join(HOME_DIR, "TTOON", "Localization", "ko.lproj", "Localizable.strings")
en_strings_file_path = os.path.join(HOME_DIR, "TTOON", "Localization", "en.lproj", "Localizable.strings")



# JSON 키 파일을 사용하여 인증
credential = ServiceAccountCredentials.from_json_keyfile_name(JSON_KEY_PATH, scope)
gc = gspread.authorize(credential)

# 스프레드시트 키 설정
spreadsheet_key = "1ILJ_xNji1SsOItaDThc79GB_bfF-2RuIbuS5xgLPFDM"
doc = gc.open_by_key(spreadsheet_key)
all_sheets = doc.worksheets()

# 명령줄 인수를 확인하여 특정 시트만 처리하도록 설정
if len(sys.argv) > 1:
    found = False
    
    # 기존 JSON 파일을 읽어서 메모리에 로드
    ko_json = read_json_file(ko_json_file_path)
    en_json = read_json_file(en_json_file_path)

    # 모든 시트를 반복하면서 입력한 시트명과 일치하는 경우 처리
    for sheet in all_sheets:
        title = sheet.title
        
        if title == sys.argv[1]:
            found = True
            process_sheet(sheet, ko_json, en_json)
            break

else:
    ko_json = {}
    en_json = {}
    
    # 모든 시트를 반복하면서 처리
    for sheet in all_sheets:
        process_sheet(sheet, ko_json, en_json)

# 완료 시간 출력
completion_time = datetime.now().strftime("%Y-%m-%d-%H:%M")
print("Localization complete:", completion_time)
