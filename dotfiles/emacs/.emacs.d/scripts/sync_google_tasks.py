#!/usr/bin/env python

import argparse
import dataclasses
import pickle
import re
import json
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import List

from google.auth.transport.requests import Request
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

# If modifying these scopes, delete the file token.pickle.
SCOPES = ['https://www.googleapis.com/auth/tasks']

LOCAL_DATA_DIR = Path.home() / '.local' / 'share' / 'org-gtd-mobile-lists'
TIMEZONE_RE = re.compile('Z$')

@dataclass
class Task:
  title: str
  completed: bool
  notes: str = None
  updated: datetime = None

  def updated_now(self):
    return dataclasses.replace(self, updated=datetime.now())

  @classmethod
  def from_emacs(cls, item):
    return cls(
      title=item['title'], completed=item['status'] == 'done'
    )

  def to_emacs(self):
    return {"title": self.title, "status": 'done' if self.completed else 'todo'}

  @classmethod
  def from_google(cls, item):
    return cls(
      title=item['title'], notes=item.get('notes'),
      completed = item['status'] == 'completed',
      updated = datetime.fromisoformat(TIMEZONE_RE.sub('+00:00', item['updated']))
    )
  def to_google(self):
    return {
      "title": self.title, "notes": self.notes,
      "status": 'completed' if self.completed else 'needsAction',
      "updated": (self.updated if self.updated else datetime.now()).astimezone().isoformat()
    }

def main():
  """Shows basic usage of the Tasks API.
  Prints the title and ID of the first 10 task lists.
  """
  parser = argparse.ArgumentParser()
  parser.add_argument("tasklist")
  parser.add_argument('tasks')

  args = parser.parse_args()
  tasks = [Task.from_emacs(i) for i in json.loads(args.tasks)]

  creds = load_credentials()
  service = build('tasks', 'v1', credentials=creds)

  tasklists = get_tasklists(service)
  ensure_tasklist(service, args.tasklist, tasklists)

  last_time = None
  last_time_file = LOCAL_DATA_DIR / 'last_sync_time'
  if last_time_file.exists():
    with open(last_time_file, 'r') as file:
      last_time = datetime.fromisoformat(file.readline().strip()).astimezone()

  changed = update_tasklist(service, tasklists[args.tasklist], tasks, since=last_time)
  for task in changed:
    print(json.dumps(task.to_emacs()))

  this_time = datetime.now().astimezone()
  with open(last_time_file, 'w') as file:
    file.write(this_time.isoformat())
    file.write('\n')

def get_tasklists(service):
  results = service.tasklists().list().execute()
  return { item['title']: item['id'] for item in results.get('items', []) }

def ensure_tasklist(service, tasklist_name, tasklists=None):
  if not tasklists:
    tasklists = get_tasklists(service)

  if tasklist_name not in tasklists:
    result = service.tasklists().insert(body={"title": tasklist_name}).execute()
    tasklists[tasklist_name] = result['id']

  return tasklists

def update_tasklist(service, tasklist_id, new_tasks: List[Task], since: datetime=None):
  """Replaces all items of the given task list and returns those that were changed since the given datetime.
  """

  results = service.tasks().list(tasklist = tasklist_id, showCompleted=True, showHidden=True).execute()
  for item in results.get('items', []):
    task = Task.from_google(item)
    if since is None or task.updated > since:
      yield task
    service.tasks().delete(tasklist=tasklist_id, task=item['id']).execute()

  previous = None
  for i, task in enumerate(new_tasks):
    previous = service.tasks().insert(tasklist=tasklist_id, body=task.updated_now().to_google(), previous=previous["id"] if previous else None).execute()
    pass

def load_credentials():
  creds = None
  LOCAL_DATA_DIR.mkdir(parents=True, exist_ok=True)

  # The file token.pickle stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  token_file = LOCAL_DATA_DIR / 'token.pickle'
  if token_file.exists():
      with open(token_file, 'rb') as token:
          creds = pickle.load(token)
  # If there are no (valid) credentials available, let the user log in.
  if not creds or not creds.valid:
      if creds and creds.expired and creds.refresh_token:
          creds.refresh(Request())
      else:
          flow = InstalledAppFlow.from_client_secrets_file(
              LOCAL_DATA_DIR / 'credentials.json', SCOPES)
          creds = flow.run_local_server(port=0)
      # Save the credentials for the next run
      with open(token_file, 'wb') as token:
          pickle.dump(creds, token)

  return creds


if __name__ == '__main__':
    main()
